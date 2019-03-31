# frozen_string_literal: true

module HallMonitor
  Configuration = Struct.new(:default_wait_time, :redis_url, :redis_host, :redis_port, :redis_db, :queue_name) do
    DEFAULTS = {
      default_wait_time: (5 * 60),
      queue_name: :default,
    }.freeze

    REDIS_NAMESPACE = "hall_monitor"

    class << self
      delegate :default_wait_time, :redis_url, :redis_db, :redis, :queue_name, to: :configuration

      def configure
        configuration.redis = nil

        yield configuration
      end

      private

      def configuration
        @configuration ||= new
      end
    end

    attr_writer :redis

    def redis
      @redis ||= Redis.new(url: redis_url, db: redis_db, namespace: REDIS_NAMESPACE)
    end

    def queue_name
      @queue_name || DEFAULTS[:queue_name]
    end
  end

  class << self
    def configuration
      Configuration
    end
  end
end
