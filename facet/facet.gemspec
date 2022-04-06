# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "facet/version"
rails_version = File.read(File.expand_path("../RAILS_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "facet"
  spec.version       = Facet::VERSION
  spec.authors       = [ "Eric Garside", "Brandon Trumpold" ]
  spec.email         = %w[eric.garside@freshly.com brandon.trumpold@gmail.com]

  spec.summary       = "A filterable, sortable, pageable, and Rails cacheable ActiveRecord::Relation"
  spec.description   = "Create cacheable collections of filtered, sorted, and paginated ActiveRecord objects"
  spec.homepage      = "https://github.com/RubyAfterAll/spicerack/tree/main/facet"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/RubyAfterAll/spicerack/blob/main/facet/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/facet/#{Facet::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_runtime_dependency "activesupport", rails_version
  spec.add_runtime_dependency "tablesalt", Facet::VERSION
  spec.add_runtime_dependency "short_circu_it", Facet::VERSION
end
