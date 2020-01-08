# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "spicery/version"

Gem::Specification.new do |spec|
  spec.name          = "spicery"
  spec.version       = Spicery::VERSION

  spec.summary       = "A suite of utility gems for Ruby on Rails."
  spec.description   = "This collection of gems will spice up your rails and kick your rubies up a notch. Bam!"
  spec.homepage      = "https://github.com/Freshly/spicerack"
  spec.license       = "MIT"

  spec.authors = [
    "Eric Garside",
    "Allen Rettberg",
    "Jordan Minneti",
    "Aleksei Kharkov",
  ]
  spec.email = %w[
    garside@gmail.com
    allen.rettberg@freshly.com
    jordan.minneti@freshly.com
    aliaksei.kharkou@freshly.com
  ]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Freshly/spicerack"
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/spicery/#{Spicery::VERSION}"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  # Spicerack Gems
  spec.add_dependency "spicerack", Spicery::VERSION
  spec.add_dependency "collectible", Spicery::VERSION
  spec.add_dependency "conjunction", Spicery::VERSION
  spec.add_dependency "facet", Spicery::VERSION
end
