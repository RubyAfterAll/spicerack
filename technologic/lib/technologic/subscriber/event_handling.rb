# frozen_string_literal: true

module Technologic
  module Subscriber
    module EventHandling
      extend ActiveSupport::Concern

      included do
        class_attribute :_event_handlers, instance_writer: false, default: []
      end

      class_methods do
        def on_event(&block)
          _event_handlers << block
        end

        def trigger(event)
          _event_handlers.each { |handler| handler.call(event) }
        end

        def inherited(base)
          base._event_handlers = _event_handlers.dup
          super
        end
      end
    end
  end
end
