version = File.read(File.expand_path("SPICERACK_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "spicerack"
  spec.version       = version
  spec.authors       = ["Eric Garside", "Allen Rettberg"]
  spec.email         = ["garside@gmail.com", "allen.rettberg@freshly.com"]

  spec.summary       = "A suite of utility gems for Ruby on Rails."
  spec.description   = "This collection of gems will spice up your rails and kick your rubies up a notch. Bam!"
  spec.homepage      = "https://www.freshly.com/"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  # Spicerack Gems
  spec.add_dependency "around_the_world", version
  spec.add_dependency "technologic", version

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.16"

  # Spicerack Development Gems
  # spec.add_development_dependency "rspice", version
end
