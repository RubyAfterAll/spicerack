# frozen_string_literal: true

module Technologic
  class Event
    include ShortCircuIt

    attr_reader :name, :duration

    def initialize(name, started, finished, payload)
      @name = name
      @duration = finished - started
      @payload = payload
    end

    def data
      {}.tap do |hash|
        hash.merge!(@payload)
        hash[:event] = name
        hash[:duration] = duration if duration.round > 0
      end
    end
    memoize :data
  end
end
