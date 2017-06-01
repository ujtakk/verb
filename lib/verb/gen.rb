require "thor"

module Verb
  class Project < Thor::Group
    include Thor::Actions

    argument :command
    argument :name

    def self.source_root
      File.expand_path("../../../", __FILE__)
    end

    def create_project
      directory "asset", name, :exclude_pattern => /template/
      empty_directory "#{name}/test"
      create_link "#{name}/rtl/test", "../test"
    end
  end

  class Template < Thor::Group
    include Thor::Actions

    argument :command
    argument :name

    def self.source_root
      File.expand_path("../../../", __FILE__)
    end

    def apply_template
      unless Dir.pwd =~ /rtl/
        abort 'ERROR: templates must be generated under the "rtl" dir.'
      end
      template "asset/template/template.v.erb", "#{name}.v.erb"
      template "asset/template/test_template.v.erb", "test/test_#{name}.v.erb"
    end
  end
end
