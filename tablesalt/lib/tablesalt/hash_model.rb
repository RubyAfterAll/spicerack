# frozen_string_literal: true

require "active_model"

module Tablesalt
  module HashModel
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Attributes

      class_attribute :_fields, instance_writer: false, default: []

      attr_accessor :hash
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
        define_method("#{name}=".to_sym) { |value| hash[name] = value }
        define_method(name) do
          write_attribute(name, hash[name] || attribute(name))
          attribute(name)
        end
      end
    end
  end
end