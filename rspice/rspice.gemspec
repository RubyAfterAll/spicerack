
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspice/version"

Gem::Specification.new do |spec|
  spec.name          = "rspice"
  spec.version       = Rspice::VERSION
  spec.authors       = ["Eric Garside"]
  spec.email         = ["garside@gmail.com"]

  spec.summary       = "Spice up your specs with this collection of custom matchers and shared contexts/examples."
  spec.description   = "A dash of spice to make your RSpec tests very nice."
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"
end
