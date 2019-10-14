# frozen_string_literal: true

# Records are the collection source, with an optional scope that is always applied before filters.
module Facet
  module Record
    extend ActiveSupport::Concern

    included do
      delegate :record_class, :record_scope, :self_scope, to: :class
    end

    class_methods do
      def record_class
        name.chomp("Facet").constantize
      end

      def self_scope
        record_class.model_name.collection.to_sym
      end

      def record_scope
        scoped? ? @record_scope : :all
      end

      def scoped?
        @record_scope.present?
      end

      def inherited(base)
        base.__send__(:scope, @record_scope) if scoped?
        super
      end

      private

      def scope(value)
        @record_scope = value
      end
    end
  end
end
