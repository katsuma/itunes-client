# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itunes/version'

Gem::Specification.new do |spec|
  spec.name          = "itunes-client"
  spec.version       = Itunes::VERSION
  spec.authors       = ["ryo katsuma"]
  spec.email         = ["katsuma@gmail.com"]
  spec.description   = %q{iTunes client with high level API}
  spec.summary       = %q{itunes-client provides a high level API like ActiveRecord style to control your iTunes.}
  spec.homepage      = "https://github.com/katsuma/itunes-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 10.0.3"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "rb-fsevent", "~> 0.9.3"
  spec.add_development_dependency "guard", "~> 1.8.1"
  spec.add_development_dependency "guard-rspec", "~> 3.0.2"
  spec.add_development_dependency "growl", "~> 1.0.3"
  spec.add_development_dependency "fakefs", "~> 0.4.2"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "coveralls", "~> 0.6.6"
  spec.add_development_dependency "pry", "~> 0.9.12.2"
end
