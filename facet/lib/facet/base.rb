# frozen_string_literal: true

require_relative "concerns/filter"
require_relative "concerns/sort"
require_relative "concerns/core"

module Facet
  class Base
    include Facet::Filter
    include Facet::Sort
    include Facet::Core
  end
end
