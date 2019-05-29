# frozen_string_literal: true

module Spicerack
  class RootObject
    include ActiveSupport::Callbacks
    include ShortCircuIt
    include Technologic
    include Tablesalt::StringableObject

    class << self
      private

      def define_callbacks_with_handler(*events, handler: :on, filter: :after)
        define_callbacks(*events)

        events.each do |event|
          define_singleton_method("#{handler}_#{event}".to_sym) do |*filters, &block|
            set_callback(event, filter, *filters, &block)
          end
        end
      end
    end
  end
end
