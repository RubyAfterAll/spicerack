# frozen_string_literal: true

require_relative "core"

module Technologic
  module Subscriber
    class Base
      include Core
    end
  end
end


# # frozen_string_literal: true
#def call(name, started, finished, _unique_id, payload)
# event = name.chomp(".#{severity}")
#
# Rails.logger.public_send(severity) do
#   payload.
#   transform_values { |value| format_value_for_log(value) }.
#   merge(event: event).
#   tap do |hash|
#     duration = (finished - started).round
#     hash[:duration] = duration unless duration == 0
#   end
# end
# end
#
# protected
#
# def severity
#   @severity ||= self.class.name.demodulize.downcase.to_sym
# end
# class ApplicationLogger
#   AUTO_ALERT_SEVERITY ||= %i[fatal warn].freeze
#
#   class << self
#     def format_value_for_log(value)
#       # TODO: ApplicationEmumerator!
#       return value.to_s if value.is_a?(Enumerator)
#       return value.id if value.respond_to?(:id)
#       return value if value.is_a?(Numeric)
#       return value.to_log_string if value.respond_to?(:to_log_string)
#       return value.map { |mappable_value| format_value_for_log(mappable_value) } if value.respond_to?(:map)
#
#       value.to_s
#     end
#   end
#
#   delegate :format_value_for_log, to: :class
#
#
#
#
#
#   def trigger_external_alert?(payload = {})
#     return AUTO_ALERT_SEVERITY.include?(severity) unless payload.key? :notify
#
#     payload[:notify]
#   end
# end
#
# class FatalLogger < ApplicationLogger; end
# class ErrorLogger < ApplicationLogger; end
# class WarnLogger < ApplicationLogger; end
# class InfoLogger < ApplicationLogger; end
# class DebugLogger < ApplicationLogger; end
#
# ActiveSupport::Notifications.subscribe(%r{\.fatal$}, FatalLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.error$}, ErrorLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.warn$}, WarnLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.info$}, InfoLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.debug$}, DebugLogger.new)
