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
end
