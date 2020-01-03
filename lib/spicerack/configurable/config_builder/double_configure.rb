# frozen_string_literal: true

require "technologic"

module Spicerack
  module Configurable
    module DoubleConfigure
      extend ActiveSupport::Concern

      include Technologic

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
          Spicerack::Configurable.configure has been called more than once, which can lead to unexpected consequences.
          For the most predictable behavior, configure should only be called once per library.
        WARNING
      end
    end
  end
end
