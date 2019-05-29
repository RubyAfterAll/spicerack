# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
require "pry"

require "shoulda-matchers"

require_relative "../lib/spicerack/version"
require_relative "../lib/spicerack/spec_helper"

require_relative "shared_examples/a_versioned_spicerack_gem"

SimpleCov.start do
  add_filter "/spec/"
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) { Redis.new.flushdb if defined?(Redis) }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
