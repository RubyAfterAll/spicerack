# frozen_string_literal: true

module Technologic
  class ConfigOptions
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
  end
end
