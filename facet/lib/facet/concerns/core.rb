# frozen_string_literal: true

# Facets are the filter/sort/pagination parameters that represent a subset of an ActiveRecord collection.
module Facet
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :current_page, :filter_by, :sort_by
    end

    def initialize(current_page: 0, filter_by: nil, sort_by: nil, all: false)
      @current_page = current_page
      @filter_by = filter_by.presence || ((default_filter? && !all) ? default_filter : nil)
      @sort_by = sort_by.presence || (default_sort? ? default_sort : nil)
    end
  end
end
