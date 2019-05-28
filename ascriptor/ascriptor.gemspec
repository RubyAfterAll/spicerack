
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ascriptor/version"

Gem::Specification.new do |spec|
  spec.name          = "ascriptor"
  spec.version       = Ascriptor::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Facilitates attribute definition on classes to easily create service object"
  spec.description   = "Service object base class for defining attributes & defaults with a nice DSL"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/ascriptor"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", "~> 5.2.1"
  spec.add_runtime_dependency "activemodel", "~> 5.2.1"

  spec.add_runtime_dependency "tablesalt", Ascriptor::VERSION
end
