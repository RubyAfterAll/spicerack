# frozen_string_literal: true

# Deletions allow for the removal of data from the Hash.
module RedisHash
  module Deletions
    extend ActiveSupport::Concern

    included do
      delegate :del, :hdel, to: :redis
    end

    def clear
      del(redis_key) and {}
    end

    def delete(field)
      run_callbacks(:deletion) do
        value = self[field]
        result = hdel(redis_key, field)
        (result == 0 && block_given?) ? yield(field) : value
      end
    end

    def shift
      return to_default if empty?

      field = keys.first
      [ field, delete(field) ]
    end
  end
end
