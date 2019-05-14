# frozen_string_literal: true

# A RedisHash is a wrapper around a h<key> stored in Redis.
module Tablesalt
  module RedisHash
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :key, :redis
      end

      def initialize(key = nil, redis: Redis.new)
        run_callbacks(:initialize) do
          @key = key || SecureRandom.hex
          @redis = redis
        end
      end
    end
  end
end
