# frozen_string_literal: true

require_relative "configurable/config"

# A utility for creating read-only gem configurations.
#
# Usage:
#   # In your gem:
#   class SomeGem::Configuration
#     include Spicerack::Configurable
#
#     option :some_config_option
#     option :some_option_with_a_default, default: "I probably know what's best"
#   end
#
#   # Then, in the application using the gem:
#   SomeGem.configure do |config|
#     config.some_config_option = 12345
#     config.some_option_with_a_default = "Nope, you really don't"
#   end
module Spicerack
  module Configurable
    extend ActiveSupport::Concern

    class_methods do
      def configure
        yield config
      end

      def option(name, *args)
        config_class.__send__(:option, name, *args)

        define_singleton_method(name) { config.public_send(name) }
      end

      private

      def config_class
        @config_class ||= const_set("Config", Class.new(Config))
      end

      def config
        @config ||= config_class.new
      end
    end
  end
end
