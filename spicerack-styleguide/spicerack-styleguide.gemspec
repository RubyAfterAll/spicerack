# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spicerack/styleguide/version"

Gem::Specification.new do |spec|
  spec.name          = "spicerack-styleguide"
  spec.version       = Spicerack::Styleguide::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "Keeps your code fresh"
  spec.description   = "Wanna write code the Freshly way? Inherit this gem in your rubocop.yml and start your engines!"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/develop/spicerack-styleguide"
  spec.license       = "MIT"

  spec.require_paths = "lib"

  spec.add_dependency "rubocop", "0.59.2"
  spec.add_dependency "rubocop-rspec", "1.29.1"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
