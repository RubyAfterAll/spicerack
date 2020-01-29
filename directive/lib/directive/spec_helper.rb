# frozen_string_literal: true

require_relative "spec_helper/matchers"
require_relative "spec_helper/dsl"

RSpec.configure do |config|
  config.include(Spicerack::RSpec::Configurable::Matchers::Global)
  config.include(Spicerack::RSpec::Configurable::Matchers::Configuration, type: :configuration)
  config.include(Spicerack::RSpec::Configurable::DSL, type: :configuration)
end
