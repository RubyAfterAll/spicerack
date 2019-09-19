# frozen_string_literal: true

# Facets are intended to work with Rails view (russian doll) caching which requires responding to `#cache_key`
module Facet
  module Cache
    extend ActiveSupport::Concern

    included do
      memoize :cache_key
    end

    def cache_key
      [ collection, current_page, filter_by, sort_by ]
    end
  end
end
