# frozen_string_literal: true

# Adapter which handles the storage and retrieval of hash data in Redis.
module RedisHash
  module Adapter
    extend ActiveSupport::Concern

    included do
      attr_reader :redis, :redis_key, :redis_ttl

      delegate :default_redis, :default_redis_key, :default_redis_ttl, to: :class

      delegate :pipelined, :multi, :exec, to: :redis

      private

      def initialize_redis(redis, redis_key, redis_ttl)
        @redis = redis || default_redis
        @redis_key = redis_key || default_redis_key
        @redis_ttl = redis_ttl || default_redis_ttl
      end
    end

    class_methods do
      def default_redis
        Redis.new
      end

      def default_redis_key
        SecureRandom.hex
      end

      def default_redis_ttl
        nil
      end
    end
  end
end
