# frozen_string_literal: true

module Spicerack
  module RSpec
    module Configurable
      module Matchers
        extend ::RSpec::Matchers::DSL
      end
    end
  end
end

require_relative "matchers/define_config_option"
