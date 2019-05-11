# frozen_string_literal: true

module Technologic
  class Setup
    class << self
      def for(application)
        technologic_config = application.config.technologic

        setup_subscribers(technologic_config)
        setup_loggers(technologic_config)
      end

      private

      def setup_subscribers(config)
        ActiveSupport::Notifications.subscribe(%r{\.fatal$}, Technologic::FatalSubscriber) if config.subscribe_to_fatal
        ActiveSupport::Notifications.subscribe(%r{\.error$}, Technologic::ErrorSubscriber) if config.subscribe_to_error
        ActiveSupport::Notifications.subscribe(%r{\.warn$}, Technologic::WarnSubscriber) if config.subscribe_to_warn
        ActiveSupport::Notifications.subscribe(%r{\.info$}, Technologic::InfoSubscriber) if config.subscribe_to_info
        ActiveSupport::Notifications.subscribe(%r{\.debug$}, Technologic::DebugSubscriber) if config.subscribe_to_debug
      end

      def setup_loggers(config)
        Technologic::FatalSubscriber.on_event { |e| Technologic::Logger.log(:fatal, e) } if config.log_fatal_events
        Technologic::ErrorSubscriber.on_event { |e| Technologic::Logger.log(:error, e) } if config.log_error_events
        Technologic::WarnSubscriber.on_event { |e| Technologic::Logger.log(:warn, e) } if config.log_warn_events
        Technologic::InfoSubscriber.on_event { |e| Technologic::Logger.log(:info, e) } if config.log_info_events
        Technologic::DebugSubscriber.on_event { |e| Technologic::Logger.log(:debug, e) } if config.log_debug_events
      end
    end
  end
end
