# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verb/version'

Gem::Specification.new do |spec|
  spec.name          = "verb"
  spec.version       = Verb::VERSION
  spec.authors       = ["Takayuki Ujiie"]
  spec.email         = ["takau@easter.kuee.kyoto-u.ac.jp"]

  spec.summary       = "Simple build tool for ERB-described Verilog project"
  spec.description   = <<~EOS
    VERB is the simple build tool for ERB-described Verilog project.
    You can use VERB to initialize ERB-Verilog project,
    create module and testbench templates, and build the rtl sources.
  EOS
  spec.homepage      = "https://github.com/ujtak/verb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "http://karafuto/gitlab/takau/verb"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_dependency "thor"
end
