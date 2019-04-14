# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spicerack/styleguide/version"

Gem::Specification.new do |spec|
  spec.name          = "spicerack-styleguide"
  spec.version       = Spicerack::Styleguide::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "Rubocop Styleguide for Rails and RSpec."
  spec.description   = "Wanna write code the Freshly way? Inherit this gem in your rubocop.yml and keep your code fresh"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/spicerack-styleguide"
  spec.license       = "MIT"

  spec.files         = Dir["rubocop.yml", "README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_dependency "rubocop", "0.59.2"
  spec.add_dependency "rubocop-rspec", "1.29.1"
end
