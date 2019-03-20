# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hall_monitor/version"

Gem::Specification.new do |spec|
  spec.name          = "hall_monitor"
  spec.version       = HallMonitor::VERSION
  spec.authors       = ["Allen Rettberg"]
  spec.email         = ["allen.rettberg@freshly.com"]

  spec.summary       = "Make sure your child processes return when they say they will"
  spec.description   = "Perks up when a method runs off after getting called, and calls the police if they get captured by a timeout"
  spec.homepage      = "https://github.com/Freshly/spicerack/tree/master/hall_monitor"
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "LICENSE.txt", "lib/**/{*,.[a-z]*}"]
  spec.require_paths = "lib"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "around_the_world", HallMonitor::VERSION
end
