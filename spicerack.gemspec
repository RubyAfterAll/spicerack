# frozen_string_literal: true

version = File.read(File.expand_path("SPICERACK_VERSION", __dir__)).strip
rails_version = File.read(File.expand_path("RAILS_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  raise StandardError, "RubyGems 2.0 or newer is required." unless spec.respond_to?(:metadata)

  spec.name          = "spicerack"
  spec.version       = version

  spec.summary       = "A suite of utility gems for Ruby on Rails."
  spec.description   = "This collection of gems will spice up your rails and kick your rubies up a notch. Bam!"
  spec.homepage      = "https://github.com/RubyAfterAll/spicerack"
  spec.license       = "MIT"

  spec.authors = [
    "Eric Garside",
    "Allen Rettberg",
    "Jordan Minneti",
    "Aleksei Kharkov",
    "Brandon Trumpold"
  ]
  spec.email = %w[
    garside@gmail.com
    allen.rettberg@freshly.com
    jordan.minneti@freshly.com
    aliaksei.kharkou@freshly.com
    brandon.trumpold@gmail.com
  ]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/RubyAfterAll/spicerack"
  spec.metadata["changelog_uri"] = "https://github.com/RubyAfterAll/spicerack/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/spicerack"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  # Spicerack Gems
  spec.add_dependency "around_the_world", version
  spec.add_dependency "directive", version
  spec.add_dependency "redis_hash", version
  spec.add_dependency "short_circu_it", version
  spec.add_dependency "substance", version
  spec.add_dependency "technologic", version
  spec.add_dependency "tablesalt", version

  spec.add_development_dependency "bundler", ">= 2.0.1"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"
  spec.add_development_dependency "faker", ">= 2.0", "< 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-nav", ">= 0.2.4"
  spec.add_development_dependency "shoulda-matchers", "~> 6.0.0"

  # Spicerack Development Gems
  spec.add_development_dependency "rspice", version
  spec.add_development_dependency "spicerack-styleguide", version

  # ActiveRecord Testing
  spec.add_development_dependency "will_paginate", "~> 3.1.1"
  spec.add_development_dependency "activerecord", rails_version
  spec.add_development_dependency "sqlite3", ">= 1.4.2", "< 2.0.0"
end
