# frozen_string_literal: true

require_relative "collection/core"
require_relative "collection/ensures_item_eligibility"
require_relative "collection/wraps_collection_methods"

module Collectible
  class CollectionBase
    include AroundTheWorld

    include Tablesalt::StringableObject
    include Tablesalt::UsesHashForEquality

    include Collectible::Collection::Core
    include Collectible::Collection::EnsuresItemEligibility
    include Collectible::Collection::WrapsCollectionMethods
  end
end
