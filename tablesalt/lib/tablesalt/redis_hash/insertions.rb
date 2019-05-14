# frozen_string_literal: true

# Insertions allow for the addition of data into the Hash.
module Tablesalt
  module RedisHash
    module Insertions
      extend ActiveSupport::Concern

      included do
        delegate :merge, to: :to_h
      end

      def merge!(other_hash)
        hmset(*other_hash.to_a.unshift(redis_key))
      end
      alias_method :update, :merge!

      def store(field, value)
        hset(redis_key, field, value)
      end
      alias_method :[]=, :store
    end
  end
end
