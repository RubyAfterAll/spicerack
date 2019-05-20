# frozen_string_literal: true

module Tablesalt
  class ArrayIndex
    class << self
      alias_method :[], :new
    end

    attr_reader :array

    delegate :[], to: :index

    def initialize(array)
      @array = array
    end

    def index
      @index ||= array.each_with_index.each_with_object({}) do |(element, index), hash|
        hash[element] = index unless hash.key?(element)
      end
    end
  end
end
