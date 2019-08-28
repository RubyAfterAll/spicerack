# frozen_string_literal: true

# Sorting allow you to control the display order of a collection or subset of records.
module Facet
  module Sort
    extend ActiveSupport::Concern

    included do
      delegate :default_sort, :default_sort?, to: :class
    end

    class_methods do
      attr_reader :default_sort

      def inherited(base)
        base.__send__(:sort_default, default_sort) if default_sort?
        super
      end

      def default_sort?
        default_sort.present?
      end

      private

      def sort_default(value)
        @default_sort = value
      end
    end
  end
end
