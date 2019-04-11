# frozen_string_literal: true

# This plays nicely with Technologic's severity logging methods, writing clean JSON rather than stringified hashes.
# Call within a `config/initializer` to replace `ActiveSupport::TaggedLogging#call` with a custom JSON log formatter.
#
#     JsonLogConverter.convert_rails_logger
#
# You can optionally provide a block to the `convert_rails_logger` method to hand-craft the log payload yourself:
#
#     JsonLogConverter.convert_rails_logger do |severity, timestamp, msg|
#       payload = { severity: severity, timestamp: timestamp }
#       payload[:tags] = current_tags if current_tags.any?
#       payload.merge(msg.is_a?(Hash) ? msg : { message: msg })
#     end

module JsonLogConverter
  def self.convert_rails_logger(&block)
    define_method(:log_payload_for, &block) if block_given?
    Rails.logger.formatter.extend self
  end

  def call(severity, timestamp, _progname, msg)
    "#{log_payload_for(severity, timestamp, msg).to_json}\n"
  end

  def default_json_payload(severity, timestamp, msg)
    payload = { severity: severity, timestamp: timestamp }
    payload[:tags] = current_tags if current_tags.any?
    payload.merge(msg.is_a?(Hash) ? msg : { message: msg })
  end

  def split_event_key_for_payload(payload)
    return payload unless payload[:event]&.include? "."

    parts = payload[:event].split(".")
    return payload unless parts.length == 2

    payload[:event] = parts[0]
    payload[:class] = parts[1]
    payload
  end

  def log_payload_for(severity, timestamp, msg)
    default_json_payload(severity, timestamp, msg)
  end
end
