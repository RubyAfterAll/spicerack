# frozen_string_literal: true

require_relative "matchers"

RSpec.configure do |config|
  config.include(Spicerack::RSpec::Configurable::Matchers, type: :configuration)
end
