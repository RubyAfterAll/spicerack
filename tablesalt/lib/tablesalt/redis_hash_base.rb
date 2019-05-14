# frozen_string_literal: true

require_relative "redis_hash/callbacks"
require_relative "redis_hash/core"
require_relative "redis_hash/identity"
require_relative "redis_hash/accessors"
require_relative "redis_hash/comparisons"
require_relative "redis_hash/predicates"

module Tablesalt
  class RedisHashBase
    include Technologic
    include Tablesalt::RedisHash::Callbacks
    include Tablesalt::RedisHash::Core
    include Tablesalt::RedisHash::Identity
    include Tablesalt::RedisHash::Accessors
    include Tablesalt::RedisHash::Comparisons
    include Tablesalt::RedisHash::Predicates
  end
end
