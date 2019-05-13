# frozen_string_literal: true

require_relative "redis_hash/callbacks"
require_relative "redis_hash/core"

module Tablesalt
  class RedisHashBase
    include Technologic
    include Tablesalt::RedisHash::Callbacks
    include Tablesalt::RedisHash::Core
  end
end
