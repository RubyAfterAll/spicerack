# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "technologic/version"
rails_version = File.read(File.expand_path("../RAILS_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "technologic"
  spec.version       = Technologic::VERSION
  spec.authors       = [ "Eric Garside" ]
  spec.email         = [ "garside@gmail.com" ]

  spec.summary       = "Logging system built on an extensible event triggering system requiring minimal implementation"
  spec.description   = "A clean and terse way to produce standardized, highly actionable, and data-rich logs"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/main/technologic"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/main/technologic/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/technologic/#{Technologic::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", rails_version
  spec.add_runtime_dependency "short_circu_it", Technologic::VERSION
end
