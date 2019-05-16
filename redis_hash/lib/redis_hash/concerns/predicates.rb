# frozen_string_literal: true

# Predicates enable querying the Hash for data.
module RedisHash
  module Predicates
    extend ActiveSupport::Concern

    included do
      delegate :hexists, to: :redis
    end

    def any?(&block)
      return length > 0 unless block_given?

      to_h.any?(&block)
    end

    def empty?
      length == 0
    end

    def include?(field)
      hexists(redis_key, field)
    end
    alias_method :has_key?, :include?
    alias_method :key?, :include?
    alias_method :member?, :include?

    def value?(value)
      values.include? value
    end
    alias_method :has_value?, :value?
  end
end
