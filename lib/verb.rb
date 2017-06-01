require "thor"
require "verb/version"
require "verb/gen"
require "verb/dep"

module Verb
  # Your code goes here...
  class CLI < Thor
    class_option :help, type: :boolean, aliases: "-h", desc: "help message."
    default_task :build

    desc "version", "Show version"
    def version
      p Verb::VERSION
    end

    desc "init", "Initialize project"
    def init(name)
      Verb::Project.start
    end

    desc "new", "Generate template of module"
    def new(name)
      Verb::Template.start
    end

    desc "dep", "Analyze dependency of sources"
    def dep(*names)
      system("cat Makefile | grep -v Makefile.dep | make -f - dep.in > /dev/null 2>&1")
      Verb::Depend.start
    end

    desc "build", "Build sources (alias to `make`)"
    def build
      system("make")
    end

    desc "test", "Build sources (alias to `make test`)"
    def test
      system("make test")
    end

    desc "dist", "Distribute built RTL (alias to `make dist`)"
    def dist
      system("make dist")
    end

    desc "clean", "Clean up sources (alias to `make clean`)"
    def clean
      system("make clean")
    end
  end
end
