# frozen_string_literal: true

# A Default allows a static or procedurally generated value to be returned on failed lookups.
module Tablesalt
  module RedisHash
    module Default
      extend ActiveSupport::Concern

      included do
        attr_reader :default_proc

        private

        def to_default(field = nil, allow_nil_field: true)
          @default.presence || (default_proc&.call(self, field) if !field.nil? || allow_nil_field)
        end
      end

      def default=(value)
        @default = value
        @default_proc = nil
      end

      def default_proc=(value)
        raise TypeError, "wrong default_proc type #{value.class.name} (expected Proc)" unless value.is_a? Proc

        if value.lambda?
          arity = value.arity
          raise TypeError, "default_proc takes two arguments (2 for #{arity})" if arity >= 0 && arity != 2
        end

        @default = nil
        @default_proc = value
      end

      def default(field = nil)
        to_default(field, allow_nil_field: false)
      end
    end
  end
end
