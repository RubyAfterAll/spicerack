# frozen_string_literal: true

require "active_job"

module HallMonitor
  class MonitorJob < (const_defined?("ApplicationJob") ? ApplicationJob : ActiveJob::Base)


    def perform(*args)
      # TODO: something
    end
  end
end
