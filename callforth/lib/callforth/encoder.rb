# frozen_string_literal: true

module Callforth
  class Encoder
    attr_reader :target_class, :method, :class_arguments, :method_arguments

    def initialize(target_class, method, class_arguments: nil, method_arguments: nil)
      @target_class = target_class
      @method = method
      @class_arguments = class_arguments
      @method_arguments = method_arguments
    end
  end
end
