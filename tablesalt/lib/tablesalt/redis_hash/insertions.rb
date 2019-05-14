# frozen_string_literal: true

# Insertions allow for the addition of data into the Hash.
module Tablesalt
  module RedisHash
    module Insertions
      extend ActiveSupport::Concern

      def store(field, value)
        hset(redis_key, field, value)
      end
      alias_method :[]=, :store
    end
  end
end
