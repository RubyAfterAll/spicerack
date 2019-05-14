# frozen_string_literal: true

# A Default allows a static or procedurally generated value to be returned on failed lookups.
module Tablesalt
  module RedisHash
    module Default
      extend ActiveSupport::Concern

      included do
        attr_writer :default
        attr_reader :default_proc

        private

        def to_default(field = nil, allow_nil_field: true)
          return @default unless @default.nil?

          default_proc&.call(self, field) if !field.nil? || allow_nil_field
        end
      end

      def default_proc=(value)
        raise TypeError, "wrong default_proc type #{value.class.name} (expected Proc)" unless value.is_a? Proc

        @default_proc = value
      end

      def default(field = nil)
        to_default(field, allow_nil_field: false)
      end
    end
  end
end
