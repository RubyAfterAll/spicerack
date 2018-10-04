# frozen_string_literal: true

module Technologic
  module Subscriber
    module Registrar
      extend ActiveSupport::Concern

      included do
        class_attribute :_handlers, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base._handlers = _handlers.dup
          super
        end

        # TODO: Event handlers...
        def register_event_handler(attribute)
          _handlers << attribute

          attr_accessor attribute
          define_attribute_methods attribute

          protected "#{attribute}=".to_sym
        end
      end
    end
  end
end




