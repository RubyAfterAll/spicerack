# frozen_string_literal: true

# Enumerators allow for the traversal and manipulation of data in the Hash.
module RedisHash
  module Enumerators
    extend ActiveSupport::Concern

    included do
      delegate :each, :each_pair, :each_key, :each_value, :reject, :select, :transform_values, to: :to_h
    end

    def delete_if
      return enum_for(__method__) unless block_given?

      each { |field, value| delete(field) if yield(field, value) }

      to_h
    end

    def keep_if
      return enum_for(__method__) unless block_given?

      delete_if { |field, value| !yield(field, value) }
    end

    def reject!(&block)
      return enum_for(__method__) unless block_given?

      original = to_h
      delete_if(&block)
      current = to_h

      (original == current) ? nil : current
    end

    def select!
      return enum_for(__method__) unless block_given?

      reject! { |*arguments| !yield(*arguments) }
    end

    def transform_values!
      return enum_for(__method__) unless block_given?

      each { |field, value| store(field, yield(value)) }

      to_h
    end
  end
end
