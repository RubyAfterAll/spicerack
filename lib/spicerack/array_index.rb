# frozen_string_literal: true

require "active_support/core_ext/object/deep_dup"
require "short_circu_it"

module Spicerack
  class ArrayIndex
    include ShortCircuIt

    class << self
      alias_method :[], :new
    end

    attr_reader :array

    delegate :[], to: :index
    delegate :<<, :push, :unshift, :concat, :to_ary, to: :array

    def initialize(*array)
      if array.length == 1 && array[0].respond_to?(:to_ary)
        @array = array[0].to_a
      else
        @array = array
      end
    end

    def index
      array.each_with_index.each_with_object({}) do |(element, index), hash|
        hash[element] = index unless hash.key?(element)
      end
    end
    memoize :index, observes: :array

    def freeze
      @array = array.deep_dup.freeze
      index.freeze

      super
    end
  end
end
