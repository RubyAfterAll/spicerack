# frozen_string_literal: true

require "active_job"

module HallMonitor
  class MonitorJob < (const_defined?("ApplicationJob") ? ApplicationJob : ActiveJob::Base)
    def perform(redis_key, method_name)
      # TODO: something
    end
  end
end
