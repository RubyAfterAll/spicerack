# frozen_string_literal: true

require "active_support"
require "active_support/inflector"

require "redis"

require "redis_hash/version"

require "redis_hash/base"

module RedisHash
  class AlreadyDefinedError < StandardError; end
end
