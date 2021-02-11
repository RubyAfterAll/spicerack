# frozen_string_literal: true

require "active_model"

module Spicerack
  # Proivdes on-demand synchronization between a `data' object and ActiveModel::Attributes
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
        define_method("#{name}=".to_sym) do |value|  
          data[name] = value
          synchronize_attribute_from_datastore(name)
        end
        define_method(name) do
          synchronize_attribute_from_datastore(name)
          attribute(name)
        end
      end
    end
      
    private

    # The data object can be anything from a normal hash to a hash-like object backed by redis.
    def synchronize_attribute_from_datastore(name)
      value = data[name]
      return if value == attribute(name)

      # ActiveModel changed the interface to this method between Rails 6.0 and 6.1
      # This method is a patch which allows this class to work with either version
      # Once support for pre rails 6.0 is sunset this should likely be removed
      if respond_to?(:_write_attribute, true)
        _write_attribute(name, value)
      else
        write_attribute(name, value)
      end
    end
  end
end
