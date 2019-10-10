# frozen_string_literal: true

# Facets output the paginated filtered and sorted collection of data they represent
module Facet
  module Collection
    extend ActiveSupport::Concern

    included do
      memoize :collection
      memoize :filtered_collection
      memoize :sorted_filtered_collection

      # Supports transparent rendering with Rails of a facet in place of a collection
      delegate :to_model, :to_partial_path, to: :collection
    end

    def collection
      (source? ? source.public_send(self_scope) : record_class).public_send(record_scope)
    end

    def output
      return sorted_filtered_collection unless current_page.present? && current_page >= 0

      sorted_filtered_collection.paginate(page: current_page)
    end

    # Template rendering checks for this method to exist and calls it to get the actual data to render
    alias_method :to_ary, :output
    alias_method :to_a, :to_ary

    private

    def sorted_filtered_collection
      return filtered_collection unless sorted?

      filtered_collection.public_send(sort_by)
    end

    def filtered_collection
      return collection unless filtered?

      collection.public_send(filter_by)
    end
  end
end
