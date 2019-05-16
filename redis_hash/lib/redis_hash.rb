require "active_support"

require "redis"

require "technologic"

require "redis_hash/version"

require "redis_hash/base"

module RedisHash
  class AlreadyDefinedError < StandardError; end
end
