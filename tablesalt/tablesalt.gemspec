# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tablesalt/version"

Gem::Specification.new do |spec|
  spec.name          = "tablesalt"
  spec.version       = Tablesalt::VERSION
  spec.authors       = [ "Jordan Minneti" ]
  spec.email         = [ "jkminneti@gmail.com" ]

  spec.summary       = "Miscellaneous helper modules, POROs, and more, that standardize common behavior"
  spec.description   = "A package of helpers that introduce some conventions and convenience for common behaviors"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/tablesalt"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/tablesalt/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/tablesalt/#{Tablesalt::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts",  "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
  spec.add_runtime_dependency "activemodel", ">= 5.2.1"
end
