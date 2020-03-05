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
    delegate_missing_to :array

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
      @array = _deep_freeze_and_dup_object(array).freeze
      index.freeze

      super
    end

    private

    def _deep_freeze_and_dup_object(obj)
      if obj.is_a?(Module)
        obj
      elsif obj.respond_to?(:transform_values)
        obj.transform_values(&method(:_deep_freeze_and_dup_object)).freeze
      elsif obj.respond_to?(:map)
        obj.map(&method(:_deep_freeze_and_dup_object)).freeze
      else
        obj.dup.freeze
      end
    end
  end
end
