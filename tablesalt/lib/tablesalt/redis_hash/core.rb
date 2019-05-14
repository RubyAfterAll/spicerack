# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module Tablesalt
  module RedisHash
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :redis_key, :redis
        delegate :del, :hdel, :hexists, :hget, :hgetall, :hkeys, :hlen, :hmget, :hmset, :hset, :hvals, to: :redis
      end

      def initialize(redis_key = nil, redis: Redis.new)
        run_callbacks(:initialize) do
          @redis_key = redis_key || SecureRandom.hex
          @redis = redis
        end
      end
    end
  end
end
