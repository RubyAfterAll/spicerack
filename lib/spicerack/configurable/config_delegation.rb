# frozen_string_literal: true

require "active_support/concern"

module Spicerack
  module Configurable
    module ConfigDelegation
      extend ActiveSupport::Concern

      CONFIGURATION_MODULE_NAME = "Configuration"

      module ClassMethods
        delegate :config, :configure, to: :_configuration_module

        private

        # Sets up delegation from a top-level class to a nested Configuration module.
        #
        # @example
        #   class SomeClass
        #     include Spicerack::Configurable::ConfigDelegation
        #
        #     delegates_to_configuration
        # end
        #
        # module SomeClass::Configuration
        #   include Spicerack::Configurable
        # end
        #
        # SomeClass.config
        # => returns SomeClass::Configuration.config
        # SomeClass.configure do { |config| # config is the yielded config object from SomeClass::Configuration.configure }
        #
        # @param config_class [Spicerack::Configurable] A module that extends Spicerack::Configurable. Defaults to the module +YourGem::Configuration+
        def delegates_to_configuration(config_class = nil)
          @_configuration_module = config_class || "#{self}::#{CONFIGURATION_MODULE_NAME}".constantize
        end

        def _configuration_module
          raise NoMethodError, "Configuration not set up for #{self}. Did you forget to call delegates_to_configuration?" if @_configuration_module.nil?

          @_configuration_module
        end
      end
    end
  end
end
