
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "root_object/version"

Gem::Specification.new do |spec|
  spec.name          = "root_object"
  spec.version       = RootObject::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "A generic baseplate object full of convenient utility methods"
  spec.description   = "Generic base class sensibly filled with convenient utilities for making great objects"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/ascriptor"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"

  spec.add_runtime_dependency "short_circu_it", RootObject::VERSION
  spec.add_runtime_dependency "tablesalt", RootObject::VERSION
  spec.add_runtime_dependency "technologic", RootObject::VERSION
end
