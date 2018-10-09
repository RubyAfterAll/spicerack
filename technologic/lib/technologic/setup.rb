# frozen_string_literal: true

module Technologic
  class Setup
    class << self
      def for(application)
        technologic_config = application.config.technologic

        setup_subscribers(technologic_config)
        setup_loggers(technologic_config)
        setup_includes(technologic_config)
      end

      private

      def setup_subscribers(config)
        ActiveSupport::Notifications.subscribe(%r{\.fatal$}, FatalSubscriber) if config.subscribe_to_fatal
        ActiveSupport::Notifications.subscribe(%r{\.error$}, ErrorSubscriber) if config.subscribe_to_error
        ActiveSupport::Notifications.subscribe(%r{\.warn$}, WarnSubscriber) if config.subscribe_to_warn
        ActiveSupport::Notifications.subscribe(%r{\.info$}, InfoSubscriber) if config.subscribe_to_info
        ActiveSupport::Notifications.subscribe(%r{\.debug$}, DebugSubscriber) if config.subscribe_to_debug
      end

      def setup_loggers(config)
        FatalSubscriber.on_event { |event| Technologic::Logger.log(:fatal, event) } if config.log_fatal_events
        ErrorSubscriber.on_event { |event| Technologic::Logger.log(:error, event) } if config.log_error_events
        WarnSubscriber.on_event { |event| Technologic::Logger.log(:warn, event) } if config.log_warn_events
        InfoSubscriber.on_event { |event| Technologic::Logger.log(:info, event) } if config.log_info_events
        DebugSubscriber.on_event { |event| Technologic::Logger.log(:debug, event) } if config.log_debug_events
      end

      def setup_includes(config)
        config.include_in_classes.each { |class_name| class_name.constantize.include(Technologic) }
      end
    end
  end
end
