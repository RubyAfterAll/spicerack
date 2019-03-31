# frozen_string_literal: true

require "active_support/core_ext/module"
require "active_support/concern"
require "redis"
require "hall_monitor/version"
require "hall_monitor/configuration"
require "around_the_world"

module HallMonitor
  extend ActiveSupport::Concern
  include AroundTheWorld

  class_methods do
    def monitor_calls_to(method_name, wait: Configuration.default_wait_time)
      around_method(method_name) do |*args|
        Monitor.watch(method_name, args) do
          super(*args)
        end
      end
    end
  end
end
