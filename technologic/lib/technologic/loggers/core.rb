# frozen_string_literal: true

module Technologic
  module Loggers
    module Core
      include ActiveSupport::Concern

      def call(name, started, finished, _unique_id, payload)
        event = name.chomp(".#{severity}")

        Rails.logger.public_send(severity) do
          payload.
          transform_values { |value| format_value_for_log(value) }.
          merge(event: event).
          tap do |hash|
            duration = (finished - started).round
            hash[:duration] = duration unless duration == 0
          end
        end
      end

      protected

      def severity
        @severity ||= self.class.name.demodulize.downcase.to_sym
      end
    end
  end
end
