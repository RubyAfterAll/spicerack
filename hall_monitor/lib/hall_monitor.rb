# frozen_string_literal: true

require "active_support/core_ext/module"
require "active_support/concern"
require "redis"
require "hall_monitor/version"
require "hall_monitor/configuration"

module HallMonitor
  extend ActiveSupport::Concern

  included do
    include AroundTheWorld
  end

  def monitor_calls_to(method_name, wait: Configuration.default_wait_time)
    around_method(method_name) do |*args|

    end
  end
end
