# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/object/inclusion"

require "spicerack/version"

require "tablesalt"

require "around_the_world"
require "short_circu_it"
require "substance"
require "technologic"

require "redis_hash"

require "spicerack/array_index"
require "spicerack/hash_model"
require "spicerack/redis_model"

module Spicerack
  class Error < StandardError; end
end
