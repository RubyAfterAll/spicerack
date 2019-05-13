# frozen_string_literal: true

# Defaults allow attributes to be initialized with a value if none have been provided.
module Instructor
  module Defaults
    extend ActiveSupport::Concern

    included do
      class_attribute :_defaults, instance_writer: false, default: {}
    end

    class_methods do
      def inherited(base)
        dup = _defaults.dup
        base._defaults = dup.each { |k, v| dup[k] = v.dup }
        super
      end

      private

      def define_default(attribute, static: nil, &block)
        _defaults[attribute] = Value.new(static: static, &block)
      end
    end

    class Value
      def initialize(static: nil, &block)
        @value = (static.nil? && block_given?) ? block : static
      end

      def value
        (@value.respond_to?(:call) ? instance_eval(&@value) : @value).dup
      end
    end
  end
end
