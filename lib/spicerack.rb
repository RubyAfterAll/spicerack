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

  RootObject = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Spicerack::RootObject", "Substance::RootObject")
  AttributeObject = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Spicerack::AttributeObject", "Substance::AttributeObject")
  InputModel = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Spicerack::InputModel", "Substance::InputModel")
  InputObject = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Spicerack::InputObject", "Substance::InputObject")
  OutputObject = ActiveSupport::Deprecation::DeprecatedConstantProxy.new("Spicerack::OutputObject", "Substance::OutputObject")
end
