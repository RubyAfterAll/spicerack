# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "technologic/version"

Gem::Specification.new do |spec|
  spec.name          = "technologic"
  spec.version       = Technologic::VERSION
  spec.authors       = [ "Eric Garside" ]
  spec.email         = [ "garside@gmail.com" ]

  spec.summary       = "Logging system built on an extensible event triggering system requiring minimal implementation"
  spec.description   = "A clean and terse way to produce standardized, highly actionable, and data-rich logs"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/technologic"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/technologic/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/technologic/#{Technologic::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", ">= 5.2.1"
  spec.add_runtime_dependency "railties", ">= 5.2.1"
  spec.add_runtime_dependency "short_circu_it", Technologic::VERSION
end
