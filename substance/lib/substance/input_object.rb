# frozen_string_literal: true

require_relative "objects/arguments"
require_relative "objects/options"

module Substance
  class InputObject < Substance::AttributeObject
    define_callbacks :initialize

    include Substance::Objects::Arguments
    include Substance::Objects::Options

    def initialize(**input)
      @input = input
      run_callbacks(:initialize) do
        input.each { |key, value| __send__("#{key}=".to_sym, value) }
      end
    end

    private

    attr_reader :input
  end
end
