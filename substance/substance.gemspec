require_relative 'lib/substance/version'

rails_version = File.read(File.expand_path("../RAILS_VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "substance"
  spec.version       = Substance::VERSION
  spec.authors       = ["Freshly Engineering"]
  spec.email         = ["eng@freshly.com"]

  spec.summary       = "Base objects for building powerful service objects"
  spec.description   = "Base objects for building powerful service objects"
  spec.homepage      = "https://github.com/Freshly/spicerack/blob/main/substance"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Freshly/spicerack/blob/main/substance"
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/spicerack/blob/main/substance/CHANGELOG.md"

  spec.files         = Dir["README.md", "LICENSE.txt", ".yardopts", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = ["lib"]

  # TODO: add dependencies
end
