# frozen_string_literal: true

# Identity relates to the specific object instance.
module RedisHash
  module Identity
    extend ActiveSupport::Concern

    included do
      delegate :hgetall, to: :redis
      delegate :inspect, :to_proc, :to_s, to: :to_h
    end

    def hash
      { redis_id: redis.id, redis_key: redis_key }.hash
    end

    def to_hash
      to_h
    end

    def to_h
      hgetall(redis_key)
    end
  end
end
