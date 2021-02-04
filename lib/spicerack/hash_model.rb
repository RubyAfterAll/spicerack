# frozen_string_literal: true

require "active_model"

module Spicerack
  module HashModel
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Attributes

      class_attribute :_fields, instance_writer: false, default: []

      attr_accessor :data
    end

    class_methods do
      def inherited(base)
        base._fields = _fields.dup
        super
      end

      private

      def field(name, type = Type::Value.new, **options)
        _fields << name
        attribute(name, type, **options)
        define_field_methods(name)
      end

      def define_field_methods(name)
        define_method("#{name}?".to_sym) { data[name].present? }
        define_method("#{name}=".to_sym) { |value| data[name] = value }
        define_method(name) do
          value = data[name] || attribute(name)

          unless value.nil?
            if respond_to?(:_write_attribute, true)
              _write_attribute(name, value)
            else
              write_attribute(name, value)
            end
          end

          attribute(name)
        end
      end
    end
  end
end
