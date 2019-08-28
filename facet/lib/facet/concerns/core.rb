# frozen_string_literal: true

module Facet
  module Core
    extend ActiveSupport::Concern

    included do
      attr_reader :current_page, :filter_by, :sort_by
    end

    def initialize(current_page: 0, filter_by: nil, sort_by: nil, all: false)
      @current_page = current_page
      @filter_by = filter_by.presence || ((default_filter? && !all) ? default_filter : nil)
      @sort_by = sort_by
    end
  end
end
