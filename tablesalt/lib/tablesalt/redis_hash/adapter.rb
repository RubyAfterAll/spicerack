# frozen_string_literal: true

# Adapter which handles the storage and retrieval of hash data in Redis.
module Tablesalt
  module RedisHash
    module Adapter
      extend ActiveSupport::Concern

      included do
        attr_reader :redis_key, :redis

        delegate :del, :hdel, :hexists, :hget, :hgetall, :hkeys, :hlen, :hmget, :hmset, :hset, :hvals, to: :redis
        delegate :default_redis, :default_redis_key, to: :class

        private

        def initialize_redis(redis, redis_key)
          @redis = redis || default_redis
          @redis_key = redis_key || default_redis_key
        end
      end

      class_methods do
        def default_redis
          Redis.new
        end

        def default_redis_key
          SecureRandom.hex
        end
      end
    end
  end
end
