# frozen_string_literal: true

# Deletions allow for the removal of data from the Hash.
module Tablesalt
  module RedisHash
    module Deletions
      extend ActiveSupport::Concern

      def clear
        del(redis_key) and {}
      end

      def delete(field)
        value = self[field]
        result = hdel(redis_key, field)
        (result == 0 && block_given?) ? yield(field) : value
      end

      def shift
        return to_default if empty?

        field = keys.first
        [ field, delete(field) ]
      end
    end
  end
end
