require "verb/version"
require "thor"

module Verb
  # Your code goes here...
  class CLI < Thor
    class_option :help, type: :boolean, aliases: "-h", desc: "help message."
    class_option :version, type: :boolean, aliases: "-v", desc: "show version"
    default_task :version

    desc "version", "Show version"
    def version
      p Verb::VERSION
    end

    desc "init", "Initialize project"
    def init
    end

    desc "module", "Generate template of module"
    def module
    end

    desc "test", "Generate template of testbench"
    def test
    end

    desc "dep", "Analyze dependency of sources (alias to `make Makefile.dep`)"
    def dep
    end

    desc "build", "Build sources (alias to `make`)"
    def build
    end

    desc "dist", "Distribute built RTL (alias to `make dist`)"
    def dist
    end
  end
end
