# frozen_string_literal: true

require "technologic"
require "pry"
module Spicerack
  module Configurable
    module Warnings
      extend ActiveSupport::Concern

      include Technologic

      included do
        set_callback :configure, :before do
          warn_on_multiple_configure_calls

          @configure_called = true
        end
      end

      private

      def configure_called?
        @configure_called
      end

      def warn_on_multiple_configure_calls
        warn <<~WARNING
          Spicerack::Configurable.configure has been called more than once, which can lead to unexpected consequences.
          For the most predictable behavior, configure should only be called once per library.
        WARNING
      end
    end
  end
end
