# frozen_string_literal: true

module Technologic
  class ConfigOptions
    include AroundTheWorld

    class_attribute :enabled, default: true

    class_attribute :subscribe_to_fatal, default: true
    class_attribute :subscribe_to_error, default: true
    class_attribute :subscribe_to_warn, default: true
    class_attribute :subscribe_to_info, default: true
    class_attribute :subscribe_to_debug, default: true

    class_attribute :log_fatal_events, default: true
    class_attribute :log_error_events, default: true
    class_attribute :log_warn_events, default: true
    class_attribute :log_info_events, default: true
    class_attribute :log_debug_events, default: true

    class_attribute :log_duration_in_ms, default: false

    # TODO: Remove with duration-as-seconds deprecation
    class << self
      around_method :log_duration_in_ms= do |*args|
        super(*args)

        @_log_duration_in_ms_set_explicitly = true
      end

      private

      def log_duration_in_ms_set_explicitly?
        !!@_log_duration_in_ms_set_explicitly
      end
    end
  end
end
