# frozen_string_literal: true

module Technologic
  class Subscriber
    def call(name, started, finished, _unique_id, payload)
      trigger Technologic::Event.new(name.chomp(".#{severity}"), started, finished, payload)
    end

    def trigger(event)

    end

    private

    def severity
      @severity ||= self.class.name.demodulize.chomp("Subscriber").downcase.to_sym
    end
  end
end
