# frozen_string_literal: true

# Filters allow you to pare down a collection of records into a meaningful subset.
module Facet
  module Filter
    extend ActiveSupport::Concern

    included do
      delegate :default_filter, :default_filter?, to: :class
    end

    class_methods do
      attr_reader :default_filter

      def inherited(base)
        base.__send__(:filter_default, default_filter) if default_filter?
        super
      end

      def default_filter?
        default_filter.present?
      end

      private

      def filter_default(value)
        @default_filter = value
      end
    end
  end
end
