# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module Tablesalt
  module RedisHash
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :redis_key, :redis
        delegate :del, :hdel, :hexists, :hget, :hgetall, :hkeys, :hlen, :hmget, :hmset, :hset, :hvals, to: :redis

        private

        def set_default(default, &block)
          raise ArgumentError, "cannot specify both block and static default" if block_given? && !default.nil?

          self.default_proc = block if block_given?
          self.default = default if default.present?
        end
      end

      def initialize(default = nil, redis_key: SecureRandom.hex, redis: Redis.new, &block)
        run_callbacks(:initialize) do
          set_default(default, &block)
          @redis_key = redis_key
          @redis = redis
        end
      end
    end
  end
end
