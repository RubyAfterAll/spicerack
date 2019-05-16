# frozen_string_literal: true

# Converters allow for other objects to be coerced into a RedisHash.
module RedisHash
  module Converters
    extend ActiveSupport::Concern

    class_methods do
      def [](*arguments)
        options = block_given? ? yield({}) : {}
        new(**options).merge!(Hash[*arguments])
      end

      def try_convert(object, &block)
        return object if object.is_a?(RedisHash)

        self[object, &block] if object.respond_to?(:to_hash)
      end
    end
  end
end
