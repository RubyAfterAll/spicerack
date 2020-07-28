# frozen_string_literal: true

module Technologic
  class Event
    include ShortCircuIt

    LOGGABLE_DURATION_THRESHOLD_MS = 0.01

    attr_reader :name, :duration

    def initialize(name, started, finished, payload)
      @name = name
      @duration = finished - started
      @payload = payload
    end

    def data
      duration_in_ms = duration * 1000

      {}.tap do |hash|
        hash.merge!(@payload)
        hash[:event] = name
        hash[:duration] = ConfigOptions.log_duration_in_ms ? duration_in_ms : duration if duration_in_ms > LOGGABLE_DURATION_THRESHOLD_MS
      end
    end
    memoize :data
  end
end
