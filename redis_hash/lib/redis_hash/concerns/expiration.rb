# frozen_string_literal: true

# Expiration ensures that volatile hashes are properly configured to expire in Redis.
module RedisHash
  module Expiration
    extend ActiveSupport::Concern

    included do
      set_callback :insertion, :before, :before_insertion
      set_callback :insertion, :after, :after_insertion

      private

      attr_writer :was_empty_before_insertion

      def before_insertion
        self.was_empty_before_insertion = empty?
      end

      def after_insertion
        expire(redis_ttl) if redis_ttl.present? && empty_before_insertion?
      end
    end

    def empty_before_insertion?
      @was_empty_before_insertion.present?
    end

    def expire(seconds)
      redis.expire(redis_key, seconds)
    end

    def ttl
      redis.ttl(redis_key)
    end

    def persist
      @redis_ttl = nil
      redis.persist(redis_key)
    end
  end
end
