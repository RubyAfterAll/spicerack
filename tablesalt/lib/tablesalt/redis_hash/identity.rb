# frozen_string_literal: true

# Identity relates to the specific object instance.
module Tablesalt
  module RedisHash
    module Identity
      extend ActiveSupport::Concern

      def hash
        { redis_id: redis.id, redis_key: redis_key }.hash
      end

      def to_hash
        self
      end

      def to_h
        hgetall(redis_key)
      end
    end
  end
end
