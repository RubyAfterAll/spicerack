# frozen_string_literal: true

module HallMonitor
  Configuration = Struct.new(:default_wait_time, :redis_url, :redis_host, :redis_port, :redis_db) do
    DEFAULTS = {
      default_wait_time: (5 * 60),
    }.freeze

    REDIS_NAMESPACE = "hall-monitor"

    class << self
      delegate :default_wait_time, :redis_url, :redis_db, :redis, to: :configuration

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
      @redis ||= Redis::Client.new(url: redis_url, db: redis_db, namespace: REDIS_NAMESPACE)
    end
  end
end
