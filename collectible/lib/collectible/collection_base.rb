# frozen_string_literal: true

require_relative "collection/core"

module Collectible
  class CollectionBase
    include Tablesalt::StringableObject
    include Tablesalt::UsesHashForEquality

    include Collectible::Collection::Core
  end
end
