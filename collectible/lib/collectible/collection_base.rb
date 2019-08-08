# frozen_string_literal: true

require_relative "collection/core"
require_relative "collection/wraps_collection_methods"
require_relative "collection/ensures_item_eligibility"

module Collectible
  class CollectionBase
    include AroundTheWorld

    include Tablesalt::StringableObject
    include Tablesalt::UsesHashForEquality

    include Collectible::Collection::Core
    include Collectible::Collection::WrapsCollectionMethods
    include Collectible::Collection::EnsuresItemEligibility
  end
end
