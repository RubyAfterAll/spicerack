# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "short_circu_it/version"

Gem::Specification.new do |spec|
  spec.name          = "short_circu_it"
  spec.version       = ShortCircuIt::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "An intelligent and feature rich memoization gem"
  spec.description   = "Memoize methods safely with parameter and dependency observation"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/short_circu_it"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/short_circu_it/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/short_circu_it/#{ShortCircuIt::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
  spec.add_runtime_dependency "around_the_world", ShortCircuIt::VERSION
end
