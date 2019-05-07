lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "callforth/version"

Gem::Specification.new do |spec|
  spec.name          = "callforth"
  spec.version       = Callforth::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Like a callback, except from a secure outside caller rather than a bound listener"
  spec.description   = "Allows you to securely call, with data, any class or instance method"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "railties", "~> 5.2.1"
end
