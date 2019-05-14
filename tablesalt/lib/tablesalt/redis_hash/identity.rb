# frozen_string_literal: true

# Identity encompasses equality and self-referential methods.
module Tablesalt
  module RedisHash
    module Identity
      extend ActiveSupport::Concern

      def hash
        { redis_id: redis.id, redis_key: redis_key }.hash
      end

      def to_hash
        self
      end

      def eql?(other)
        other.hash == hash
      end
      alias_method :==, :eql?
    end
  end
end
