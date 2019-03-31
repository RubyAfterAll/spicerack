# frozen_string_literal: true

module HallMonitor
  class Monitor
    REDIS_KEY = "hall_passes"

    class << self
      def watch(method_name, args, &block)
        new(method_name, args).watch(&block)
      end

      # def clear(me)
    end

    attr_reader :method_name, :args

    def initialize(method_name, args)
      @method_name = method_name
      @args = args
    end

    def watch
      set_redis_key

      yield
    ensure
      clear_redis_key
    end

    private

    def set_redis_key
      puts "setting redis key"
      redis.hset(REDIS_KEY, hash, true)
    end

    def clear_redis_key
      puts "clearing redis key"
      redis.hdel(REDIS_KEY, hash)
    end

    def redis
      HallMonitor.configuration.redis
    end
  end
end
