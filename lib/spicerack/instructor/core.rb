# frozen_string_literal: true

# An Instructor accepts input represented by arguments and options which initialize it.
module Instructor
  module Core
    extend ActiveSupport::Concern

    attr_reader :input

    def initialize(**input)
      @input = input
      run_callbacks(:initialize) do
        input.each { |key, value| __send__("#{key}=".to_sym, value) }
      end
    end
  end
end
