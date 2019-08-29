# frozen_string_literal: true

# Facets are the filter/sort/pagination parameters that represent a subset of an ActiveRecord collection.
module Facet
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :current_page, :filter_by, :sort_by
    end

    def initialize(current_page: nil, filter_by: nil, sort_by: nil, all: false, paginate: true)
      @current_page = page_for(current_page, paginate)
      @filter_by = filter_for(filter_by, all)
      @sort_by = sort_for(sort_by)
    end

    def filtered?
      filter_by.present?
    end

    def sorted?
      sort_by.present?
    end

    private

    def page_for(current_page, paginate)
      return current_page.presence || default_page if paginate && paginated?

      raise ArgumentError, "pagination is disabled for this facet." if current_page.present?
    end

    def filter_for(filter_by, all)
      filter_by.presence || ((default_filter? && !all) ? default_filter : nil)
    end

    def sort_for(sort_by)
      sort_by.presence || (default_sort? ? default_sort : nil)
    end
  end
end
