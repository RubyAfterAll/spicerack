# frozen_string_literal: true

# A Default allows a static or procedurally generated value to be returned on failed lookups.
module RedisHash
  module Default
    extend ActiveSupport::Concern

    included do
      attr_reader :default_proc

      private

      def initialize_default(default, &block)
        raise ArgumentError, "cannot specify both block and static default" if block_given? && default.present?

        set_default(default, &block)
      end

      def set_default(default, &block)
        self.default = default if default.present?
        self.default_proc = block if block_given?
      end

      def to_default(field = nil, allow_nil_field: true)
        @default.presence || (default_proc&.call(self, field) if !field.nil? || allow_nil_field)
      end

      def validate_proc(proc)
        raise TypeError, "wrong default_proc type #{proc.class.name} (expected Proc)" unless proc.is_a? Proc

        validate_lambda_arity(proc.arity) if proc.lambda?
      end

      def validate_lambda_arity(arity)
        raise TypeError, "default_proc takes two arguments (2 for #{arity})" if arity >= 0 && arity != 2
      end
    end

    def default=(value)
      @default = value
      @default_proc = nil
    end

    def default_proc=(value)
      validate_proc(value) unless value.nil?

      @default = nil
      @default_proc = value
    end

    def default(field = nil)
      to_default(field, allow_nil_field: false)
    end
  end
end
