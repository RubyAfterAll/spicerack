# frozen_string_literal: true

require_relative "redis_hash/callbacks"
require_relative "redis_hash/core"
require_relative "redis_hash/cached_hash"

module Tablesalt
  class RedisHashBase
    include Technologic
    include Tablesalt::RedisHash::Callbacks
    include Tablesalt::RedisHash::Core
    include Tablesalt::RedisHash::CachedHash
  end
end
