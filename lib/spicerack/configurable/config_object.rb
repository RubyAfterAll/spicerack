# frozen_string_literal: true

module Spicerack
  module Configurable
    class ConfigObject < InputObject
      include Singleton
      include ActiveModel::AttributeAssignment

      alias_method :assign, :assign_attributes

      RESERVED_WORDS = %i[config_eval].freeze

      class_attribute :_nested_options, instance_writer: false, default: []
      class_attribute :_nested_builders, instance_writer: false, default: {}

      class << self
        def name
          super.presence || "#{superclass}:0x#{object_id.to_s(16)}"
        end

        def inspect
          "#<#{name}>"
        end

        private

        def option(name, *)
          _ensure_safe_option_name(name)

          super
        end

        def nested(namespace, &block)
          _ensure_safe_option_name(namespace)

          nested_config_builder_for(namespace).tap do |builder|
            builder.instance_exec(&block)

            _nested_options << namespace.to_sym
            define_method(namespace) { builder.__send__ :configuration }
          end
        end

        def nested_config_builder_for(namespace)
          _nested_builders[namespace.to_sym] ||= ConfigBuilder.new
        end

        def _ensure_safe_option_name(name)
          raise ArgumentError, "#{name.inspect} is reserved and cannot be used at a config option" if name.to_sym.in? RESERVED_WORDS
          raise ArgumentError, "#{name.inspect} is already in use" if _nested_options.include?(name.to_sym)

          puts "Warning: the config option #{name} is already defined" if _options.include?(name.to_sym) # rubocop:disable Rails/Output
        end

        def inherited(base)
          base._nested_options = _nested_options.dup
          base._nested_builders = _nested_builders.dup
          super
        end
      end
    end
  end
end