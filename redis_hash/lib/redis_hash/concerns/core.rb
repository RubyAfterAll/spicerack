# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module RedisHash
  module Core
    extend ActiveSupport::Concern

    def initialize(default = nil, redis_key: nil, redis: nil, &block)
      run_callbacks(:initialize) do
        initialize_default(default, &block)
        initialize_redis(redis, redis_key)
      end
    end
  end
end
