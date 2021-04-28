# frozen_string_literal: true

require "active_support/concern"

module Directive
  module DoubleConfigure
    extend ActiveSupport::Concern

    included do
      set_callback :configure, :after, :warn_on_multiple_configure_calls
    end

    private

    def configure_called?
      @configure_called
    end

    def warn_on_multiple_configure_calls
      unless configure_called?
        @configure_called = true
        return
      end

      puts <<~WARNING
        #{self.class._configurable_module_name}.configure has been called more than once, which can lead to unexpected consequences.
        For the most predictable behavior, configure should only be called once.
      WARNING
    end

    module ClassMethods
      def _configurable_module_name
        name.gsub("::#{name.demodulize}", "")
      end
    end
  end
end
