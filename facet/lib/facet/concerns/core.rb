# frozen_string_literal: true

# Facets are the filter/sort/pagination parameters that represent a subset of an ActiveRecord collection.
module Facet
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :current_page, :filter_by, :sort_by
      delegate :default_page, to: :class
    end

    class_methods do
      def default_page
        0
      end
    end

    def initialize(current_page: default_page, filter_by: nil, sort_by: nil, all: false)
      @current_page = current_page
      @filter_by = filter_by.presence || ((default_filter? && !all) ? default_filter : nil)
      @sort_by = sort_by.presence || (default_sort? ? default_sort : nil)
    end

    def filtered?
      filter_by.present?
    end

    def sorted?
      sort_by.present?
    end
  end
end
