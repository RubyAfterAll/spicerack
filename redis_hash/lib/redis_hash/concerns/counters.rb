# frozen_string_literal: true

# Counters allow for the incrementing and decrementing of numeric values into the RedisHash.
module RedisHash
  module Counters
    extend ActiveSupport::Concern

    included do
      delegate :hincrby, :hincrbyfloat, to: :redis

      private

      def increment_field_by(field, by, modifier: 1)
        raise ArgumentError, "by must be greater than or equal to 0" if by < 0

        by *= modifier

        return hincrbyfloat(redis_key, field, by) if by.is_a?(Float)

        hincrby(redis_key, field, by)
      end
    end

    def increment(field, by: 1)
      increment_field_by(field, by)
    end

    def decrement(field, by: 1)
      increment_field_by(field, by, modifier: -1)
    end
  end
end
