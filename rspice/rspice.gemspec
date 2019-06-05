# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspice/version"

Gem::Specification.new do |spec|
  spec.name          = "rspice"
  spec.version       = Rspice::VERSION
  spec.authors       = [ "Eric Garside" ]
  spec.email         = [ "garside@gmail.com" ]

  spec.summary       = "An `RSpec` utility gem of custom matchers, shared contexts and examples"
  spec.description   = "A dash of custom matchers, a pinch of shared contexts, and shared examples (to taste) for RSpec"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/rspice"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/rspice/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "faker", "~> 1.8"
end
