# frozen_string_literal: true

require "active_support/concern"

module Spicerack
  module Configurable
    module ConfigDelegation
      extend ActiveSupport::Concern

      module ClassMethods
        delegate :config, :configure, to: :_configuration_module

        private

        def _configuration_module
          raise NoMethodError, "Configuration not set up for #{self}. Did you forget to call delegates_to_configuration?" if @_configuration_module.nil?

          @_configuration_module
        end

        def delegates_to_configuration(config_class = nil)
          @_configuration_module = config_class || "#{self}::Configuration".constantize
        end
      end
    end
  end
end
