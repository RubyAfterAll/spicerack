# frozen_string_literal: true

module HallMonitor
  class MonitorJob < (const_defined?(ApplicationJob) ? ApplicationJob : ActiveJob::Base)
    queue_as Configuration.queue_name

    def perform(*args)
      # TODO: something
    end
  end
end
