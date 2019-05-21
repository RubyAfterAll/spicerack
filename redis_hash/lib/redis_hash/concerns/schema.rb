# frozen_string_literal: true

# Schema allow for the enforcement of a whitelist on the keys of the Hash.
module RedisHash
  module Schema
    extend ActiveSupport::Concern

    included do
      class_attribute :_allowed_keys, instance_writer: false, default: []

      delegate :_allowed_keys, to: :class

      private

      def assert_keys_allowed(*keys)
        return true if _allowed_keys.empty?

        impermissible = keys.flatten.map(&:to_sym) - _allowed_keys
        return true if impermissible.empty?

        raise ArgumentError, "Impermissible #{"key".pluralize(impermissible.length)}: #{impermissible.join(", ")}"
      end
    end

    class_methods do
      def inherited(base)
        base._allowed_keys = _allowed_keys.dup
        super
      end

      private

      def allow_keys(*keys)
        _allowed_keys.push(*keys.flatten.map(&:to_sym))
      end
    end
  end
end
