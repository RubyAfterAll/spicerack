# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module Tablesalt
  module RedisHash
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :key, :redis
        delegate :del, :hdel, :hexists, :hget, :hgetall, :hkeys, :hlen, :hmget, :hmset, :hset, :hvals, to: :redis
      end

      def initialize(key = nil, redis: Redis.new)
        run_callbacks(:initialize) do
          @key = key || SecureRandom.hex
          @redis = redis
        end
      end
    end
  end
end
