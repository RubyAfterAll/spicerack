# frozen_string_literal: true

require_relative "concerns/record"
require_relative "concerns/paginate"
require_relative "concerns/filter"
require_relative "concerns/sort"
require_relative "concerns/core"
require_relative "concerns/collection"
require_relative "concerns/cache"

module Facet
  class Base
    include ShortCircuIt

    include Facet::Record
    include Facet::Paginate
    include Facet::Filter
    include Facet::Sort
    include Facet::Core
    include Facet::Collection
    include Facet::Cache
  end
end
