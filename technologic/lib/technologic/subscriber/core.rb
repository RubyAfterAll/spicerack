# frozen_string_literal: true

module Technologic
  module Subscriber
    module Core
      extend ActiveSupport::Concern

      class_methods do
        def call(name, started, finished, _unique_id, payload)
          trigger Technologic::Event.new(name.chomp(".#{severity}"), started, finished, payload)
        end

        def severity
          @severity ||= name.demodulize.chomp("Subscriber").downcase.to_sym
        end
      end
    end
  end
end
