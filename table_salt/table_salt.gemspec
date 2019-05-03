
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "table_salt/version"

Gem::Specification.new do |spec|
  spec.name          = "table_salt"
  spec.version       = TableSalt::VERSION
  spec.authors       = ["Jordan Minneti"]
  spec.email         = ["jkminneti@gmail.com"]

  spec.summary       = "Miscellaneous modules and more, for use in spicerack-powered applications"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"
end
