lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "around_the_world/version"

Gem::Specification.new do |spec|
  spec.name          = "around_the_world"
  spec.version       = AroundTheWorld::VERSION
  spec.authors       = ["Allen Rettberg"]
  spec.email         = ["allen.rettberg@freshly.com"]

  spec.summary       = "A metaprogramming library which allows you to wrap any method easily."
  spec.description   = "Why metaprogram like a chump when you can do it like a champ!"
  spec.homepage      = "https://www.freshly.com"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end

