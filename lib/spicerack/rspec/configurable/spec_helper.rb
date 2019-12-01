# frozen_string_literal: true

require_relative "matchers"
require_relative "dsl"

RSpec.configure do |config|
  config.include(Spicerack::RSpec::Configurable::Matchers::Configuration, type: :configuration)
  config.include(Spicerack::RSpec::Configurable::DSL, type: :configuration)
end
