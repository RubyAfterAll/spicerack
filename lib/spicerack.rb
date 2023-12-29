# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/object/inclusion"

require "spicerack/version"

require "around_the_world"
require "short_circu_it"
require "substance"
require "tablesalt"
require "technologic"

require "redis_hash"

require "spicerack/array_index"
require "spicerack/hash_model"
require "spicerack/redis_model"

module Spicerack
  class Error < StandardError; end

  include ActiveSupport::Deprecation::DeprecatedConstantAccessor

  const_deprecator = ActiveSupport::Deprecation.new

  deprecate_constant :RootObject, "Substance::RootObject", deprecator: const_deprecator
  deprecate_constant :AttributeObject, "Substance::AttributeObject", deprecator: const_deprecator
  deprecate_constant :InputModel, "Substance::InputModel", deprecator: const_deprecator
  deprecate_constant :InputObject, "Substance::InputObject", deprecator: const_deprecator
  deprecate_constant :OutputObject, "Substance::OutputObject", deprecator: const_deprecator
end
