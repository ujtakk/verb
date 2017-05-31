#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'pp'

class VFile
  attr_reader(:filename)
  attr_reader(:module_name)

  class << self
    def read_ignore_list(file)
      @@ignore_file = []
      @@ignore_com = []
      # data_hash = {}
      data = open(file).read
      data = data.gsub(/#.*$/, "")    # ignore comment
                 .gsub(/\s+/im, " ")  # gather spaces to single space
      data.scan(/(\S+)\s*\{(.*?)\}/).each do |i|
        type, d = i
        d = d.strip.split(/\s+/)
        case type
        when "ignore_file"
          @@ignore_file = d
        when "ignore_com"
          @@ignore_com = d.map{|j| "#{j}.com"}
        else
          raise
        end
      end
    end
  end

  def initialize(module_name)
    @module_name = module_name
    @filename    = module_name + ".v"
    @filename_body, @filename_ext = @filename.scan(/^([^.]*)\.(.*)$/)[0]
    @dep = nil
  end

  def have_v_in
    if have_v_erb
      true
    else
      File.exist?(v_in)
    end
  end

  def have_v_erb
    File.exist?(v_erb)
  end

  def v_in;  @filename_body + ".v.in"  end
  def v_erb; @filename_body + ".v.erb" end
  def com;   @filename_body + ".com"   end

  def walk(files)
    r = ""
    files << @filename

    # append dependency for *.v
    if have_v_in and not dep.empty?
      r += <<~EOF
        #{@filename}: #{dep*" "}
      EOF
    end

    # append dependency for *.v.in
    if have_v_erb
      r += <<~EOF
        #{v_in}: #{v_erb}
      EOF
      files << v_in
    end

    # append dependency for
    if not @@ignore_com.include?(com) and
       not (c = com_dep).empty? and
       not com =~ /</
    then
      r += <<~EOF
        #{com}: #{c*" "}
      EOF
      files << com
      c.each do |i|
        if i =~ /\.vh$/
          files << i
        end
      end
    end

    submodules.each do |i|
      if not files.include?(i + ".v")
        next if @@ignore_file.include?(i) or i =~ /</
        files << i + ".v"
        r += self.class.new(i).walk(files)
      end
    end

    return r
  end

  def com_dep
    r = includes + submodules.map{|i| self.class.new(i).com}
    r.delete_if{|i| @@ignore_com.include?(i) or i =~ /</}
    return r
  end

  def dep
    return @dep if @dep != nil
    @dep = []
#    @dep<< v_in if have_v_in
    s = submodules
    @dep += s.map{|i| i + ".v"}
    @dep.delete_if{|i| i =~ /</}
    @dep
  end

  def data
    return @data if @data != nil
    if have_v_erb
      @data = open(v_erb).read
    elsif have_v_in
      @data = open(v_in).read
    else
      if File.exist?(filename)
        @data = open(filename).read
      else
        @data = ""
      end
    end

    return @data
  end

  def _submodules(str)
    v_files = []
    data0 = str.scan(/([a-zA-Z_0-9]+)\s+\S+\s*\((?:\s*\.\S+\s*\([^\)]*\)\s*,{0,1}){0,}(?:\s*\/\*AUTOINST\*\/\s*){1}\);/).map do |i|
      i[0]
    end
    v_files += data0
    data1 = str.scan(/([a-zA-Z_0-9]+)\s+\S+\s*\((?:\s*\.\S+\s*\([^\)]*\)\s*,{0,1}){1,}\);/).map do |i|
      i[0]
    end
    v_files += data1
    return v_files.uniq
  end

  def submodules
    v_files = _submodules(data)
    sdata = data.gsub(/\/\/.*$/, "")      # ignore 1-line comments
                .gsub(/\/\*.*?\*\//, "")  # ignore multi-line comments
                .gsub(/\s+/, " ")         # condense spaces
    v_files += _submodules(sdata)
    r = v_files
    r = r.uniq.sort
    return r
  end

  def includes
    v_files = data.scan(/^\s*`include\s+"([^"]*)"\s*$/).map do |i|
      [i[0]] + VHFile.new(i[0]).includes
    end
    return v_files.flatten.uniq
  end

  def to_dot_sub
    r = []
    r << "node_#{@filename_body} [label=\"#{@filename_body}\"];"
    r += submodules.map{|i|
      next if i =~ /</

      k = self.class.new(i).to_dot_sub
      r << "node_#{@filename_body}->node_#{i};"
      k
    }
    r.flatten * "\n"
  end

  def to_dot
    <<~EOF
      digraph sample {
      #{to_dot_sub}
      }
    EOF
  end
end

class VHFile < VFile
  def initialize(filename)
    @filename = filename
    @filename_body, @filename_ext = @filename.scan(/^([^.]*)\.(.*)$/)[0]
    @dep = nil
  end

  def vh_erb; @filename_body + ".vh.erb" end

  def have_vh_erb
    File.exist?(vh_erb)
  end

  def data
    return @data if @data != nil
    if have_vh_erb
      @data = open(vh_erb).read
    else
      if File.exist?(filename)
        @data = open(filename).read
      else
        @data = ""
      end
    end

    return @data
  end
end

class VFiles < Array
  def to_s
    f = self.uniq
    f = purge(f)
    f = f.sort * " \\\n\t" + "\n"
    "#{name}= \\\n\t#{f}\n"
  end

  def name
    "VFILES"
  end

  def purge(f)
    f.delete_if{|i| not i =~ /\.v$/}
    f.delete_if{|i| i =~ /^alt/}
  end
end

class VHFiles < VFiles
  def name
    "VHFILES"
  end
  def purge(f)
    f.delete_if{|i| not i =~ /\.vh$/}
    f.delete_if{|i| i =~ /^alt/}
  end
end

############################################################
# Main routine
############################################################

options = OpenStruct.new
options.mode = :make
opts = OptionParser.new do |opt|
  opt.on("--dc","design compiler readfile script") do |i|
    options.mode = :dc
  end
  opt.on("--dot","generate dot file") do |i|
    options.mode = :dot
  end
  opt.on("--make","generate Makefile (default)") do |i|
    options.mode = :make
  end
  opt.on_tail("-h", "--help", "Show this message") do
    puts opt
    exit
  end
end
opts.parse!(ARGV)

VFile.read_ignore_list("dep.in")

files_all = []
top_vfiles = ARGV.map{|top| VFile.new(top)}

top_vfiles_s = top_vfiles.map{|t|
  files = []
  r = t.walk(files)
  files_all += files

  f = files.uniq
  f.delete_if{|i| not i =~ /\.v$/}
  f.delete_if{|i| i =~ /^alt/}

  k = t.module_name
  r += "\n"
  r += "#{k}_FILES= \\\n\t"
  r += "#{f*" \\\n\t"}\n"
  r += "\n"
  r
}

files = files_all

if options.mode == :make
  print "## -*- makefile -*-\n"
  print VFiles.new(files.dup).to_s
  print VHFiles.new(files.dup).to_s
  print top_vfiles_s * "\n"
elsif options.mode == :dc
  files.delete_if{|i| not i =~ /\.v$/}
  print files.uniq.map{|i| "read_file -format verilog #{i}\n"}*""
elsif options.mode == :dot
  top_vfiles.each do |t|
    print t.to_dot
  end
end
