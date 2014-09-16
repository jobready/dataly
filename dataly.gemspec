# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dataly/version'

Gem::Specification.new do |spec|
  spec.name = "dataly"
  spec.version = Dataly::VERSION
  spec.authors = ["Andrew McNamara"]
  spec.email = ["andrewm@jobready.com.au"]
  spec.summary = %q{Simple data import from CSV.}
  spec.description = %q{This gem allows you to define a mapper class, and a creator class to import data into your application via CSV.}
  spec.homepage = ""
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency 'activesupport', "~> 4.0"
end
