# frozen_string_literal: true

# A Default allows a static or procedurally generated value to be returned on failed lookups.
module Tablesalt
  module RedisHash
    module Default
      extend ActiveSupport::Concern

      included do
        attr_writer :default
        attr_reader :default_proc
      end

      def default_proc=(value)
        raise TypeError, "wrong default_proc type #{value.class.name} (expected Proc)" unless value.is_a? Proc

        @default_proc = value
      end

      def default(field = nil)
        return @default unless @default.nil?
        return if field.nil? || default_proc.nil?

        default_proc.call(self, field)
      end
    end
  end
end
