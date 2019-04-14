
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "technologic/version"

Gem::Specification.new do |spec|
  spec.name          = "technologic"
  spec.version       = Technologic::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Logging system built on an extensible event triggering system requiring minimal implementation"
  spec.description   = "An clean and terse way to produce standardized, highly actionable, and data-rich logs"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "railties", "~> 5.2.1"
  spec.add_runtime_dependency "short_circu_it", Technologic::VERSION
end
