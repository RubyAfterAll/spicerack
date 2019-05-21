# frozen_string_literal: true

# An Instructor's attributes provide accessors to the input data it was initialized with.
module Instructor
  module Attributes
    extend ActiveSupport::Concern

    included do
      include ActiveModel::AttributeMethods

      class_attribute :_attributes, instance_writer: false, default: []
    end

    class_methods do
      def inherited(base)
        base._attributes = _attributes.dup
        super
      end

      private

      def define_attribute(attribute)
        _attributes << attribute

        attr_accessor attribute
        define_attribute_methods attribute
      end
      alias_method :attribute, :define_attribute
    end

    private

    def stringable_attributes
      self.class._attributes
    end
  end
end
