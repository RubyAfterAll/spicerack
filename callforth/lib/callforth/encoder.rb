# frozen_string_literal: true

module Callforth
  class Encoder
    attr_reader :target_class, :method, :class_method, :class_arguments, :method_arguments

    class << self
      def encode(target_class, method, class_method: false, class_arguments: nil, method_arguments: nil)
        new(
          target_class,
          method,
          class_method: class_method,
          class_arguments: class_arguments,
          method_arguments: method_arguments,
        ).encode
      end
    end

    def initialize(target_class, method, class_method: false, class_arguments: nil, method_arguments: nil)
      @target_class = target_class
      @method = method
      @class_method = class_method
      @class_arguments = class_arguments
      @method_arguments = method_arguments
    end

    def encode
      :encoded
    end
  end
end
