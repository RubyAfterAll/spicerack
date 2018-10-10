
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "short_circu_it/version"

Gem::Specification.new do |spec|
  spec.name          = "short_circu_it"
  spec.version       = ShortCircuIt::VERSION
  spec.authors       = ["Allen Rettberg"]
  spec.email         = ["allen.rettberg@freshly.com"]

  spec.summary       = "Effortless memoization"
  spec.description   = "Memoize methods safely with parameter and dependency observation"
  spec.homepage      = "https://www.freshly.com/"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "around_the_world", ShortCircuIt::VERSION
end
