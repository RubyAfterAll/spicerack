# frozen_string_literal: true

# Comparisons encompasses equality and set inclusion.
module Tablesalt
  module RedisHash
    module Comparisons
      extend ActiveSupport::Concern

      included do
        delegate :<, :<=, :>, :>=, :compare_by_identity, :compare_by_identity?, to: :to_h
      end

      def eql?(other)
        other.hash == hash
      end
      alias_method :==, :eql?
    end
  end
end
