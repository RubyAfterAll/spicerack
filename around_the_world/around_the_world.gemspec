# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "around_the_world/version"

Gem::Specification.new do |spec|
  spec.name          = "around_the_world"
  spec.version       = AroundTheWorld::VERSION
  spec.authors       = [ "Allen Rettberg" ]
  spec.email         = [ "allen.rettberg@freshly.com" ]

  spec.summary       = "Allows you to easily wrap methods with custom logic on any class"
  spec.description   = "A metaprogramming module which allows you to wrap any method easily"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/around_the_world"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/around_the_world/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/around_the_world/#{AroundTheWorld::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
end
