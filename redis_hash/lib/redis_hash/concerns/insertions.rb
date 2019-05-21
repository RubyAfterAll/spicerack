# frozen_string_literal: true

# Insertions allow for the addition of data into the RedisHash.
module RedisHash
  module Insertions
    extend ActiveSupport::Concern

    included do
      delegate :hmset, :hset, :hsetnx, to: :redis
      delegate :merge, to: :to_h
    end

    def merge!(other_hash)
      assert_keys_allowed(other_hash.keys)
      run_callbacks(:insertion) { hmset(*other_hash.to_a.unshift(redis_key)) }

      self
    end
    alias_method :update, :merge!

    def store(field, value)
      assert_keys_allowed(field)
      run_callbacks(:insertion) { hset(redis_key, field, value) }
    end
    alias_method :[]=, :store

    def setnx!(field, value)
      assert_keys_allowed(field)
      run_callbacks(:insertion) do
        success = hsetnx(redis_key, field, value)

        raise RedisHash::AlreadyDefinedError, "#{field} already defined" unless success
      end

      true
    end

    def setnx(field, value)
      setnx!(field, value)
    rescue RedisHash::AlreadyDefinedError
      false
    end
  end
end
