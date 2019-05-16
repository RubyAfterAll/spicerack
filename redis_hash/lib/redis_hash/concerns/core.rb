# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module RedisHash
  module Core
    extend ActiveSupport::Concern

    def initialize(default = nil, redis: nil, redis_key: nil, redis_ttl: nil, &block)
      run_callbacks(:initialize) do
        initialize_default(default, &block)
        initialize_redis(redis, redis_key, redis_ttl)
      end
    end
  end
end
