# frozen_string_literal: true

# Defaults are used as the value when then attribute is unspecified.
module Spicerack
  module Objects
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
        include Tablesalt::Isolation

        def initialize(static: nil, &block)
          @value = (static.nil? && block_given?) ? block : static
        end

        def value
          isolate(@value.respond_to?(:call) ? instance_eval(&@value) : @value)
        end
      end
    end
  end
end
