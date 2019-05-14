# frozen_string_literal: true

# Accessors are an adapter conforming a Redis hash to a Hashy object.
module Tablesalt
  module RedisHash
    module Accessors
      extend ActiveSupport::Concern

      included do
        delegate :hgetall, to: :redis
      end

      def to_h
        hgetall(redis_key)
      end
    end
  end
end
