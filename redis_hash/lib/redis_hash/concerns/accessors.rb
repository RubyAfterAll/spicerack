# frozen_string_literal: true

# Accessors allow for the retrieval of data from the Hash.
module RedisHash
  module Accessors
    extend ActiveSupport::Concern

    included do
      delegate :hget, :hkeys, :hlen, :hmget, :hvals, to: :redis
      delegate :assoc, :compact, :dig, :fetch_values, :flatten, :key, :rassoc, :rehash, to: :to_h
    end

    def [](field)
      hget(redis_key, field) || default(field)
    end

    def fetch(field, default = nil)
      value = self[field]
      return value if value.present?
      return yield(field) if block_given?
      return default unless default.nil?

      raise KeyError, "key not found: \"#{field}\""
    end

    def keys
      hkeys(redis_key)
    end

    def length
      hlen(redis_key)
    end
    alias_method :size, :length

    def values
      hvals(redis_key)
    end

    def values_at(*fields)
      hmget(*fields.flatten.unshift(redis_key))
    end
  end
end
