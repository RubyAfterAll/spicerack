# frozen_string_literal: true

module Spicerack
  class ArrayIndex
    include ShortCircuIt

    class << self
      alias_method :[], :new
    end

    attr_reader :array

    delegate :[], to: :index

    def initialize(array)
      @array = array
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
