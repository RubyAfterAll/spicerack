# frozen_string_literal: true

# The CachedHash is an in-memory copy of the last known state of the hash in Redis.
module Tablesalt
  module RedisHash
    module CachedHash
      extend ActiveSupport::Concern

      included do
        set_callback(:initialize, :after) { reload }
        set_callback :reload, :around, ->(_, block) { surveil(:reload) { block.call } }

        private

        attr_reader :_cached_hash
      end

      def reload
        run_callbacks(:reload) { @_cached_hash = hgetall(key) }
        self
      end
    end
  end
end
