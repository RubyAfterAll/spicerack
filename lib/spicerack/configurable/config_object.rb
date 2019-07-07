# frozen_string_literal: true

module Spicerack
  module Configurable
    class ConfigObject < InputObject
      class_attribute :_nested_options, instance_writer: false, default: []
      class_attribute :_nested_readers, instance_writer: false, default: {}

      class << self
        def nested(namespace, &block)
          nested_config_builder = ConfigBuilder.new

          nested_config_builder.instance_exec(block) do |nested_block|
            configure do
              instance_exec(&nested_block)
            end
          end

          define_method(namespace) { nested_config_builder.__send__ :configuration }

          _nested_options << namespace.to_sym
          _nested_readers[namespace.to_sym] = nested_config_builder.reader
        end

        def inspect
          "#<#{superclass}:0x#{object_id.to_s(16)}>"
        end
      end
    end
  end
end
