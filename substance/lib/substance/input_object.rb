# frozen_string_literal: true

require_relative "objects/arguments"
require_relative "objects/options"

module Spicerack
  class InputObject < Spicerack::AttributeObject
    define_callbacks :initialize

    include Spicerack::Objects::Arguments
    include Spicerack::Objects::Options

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
