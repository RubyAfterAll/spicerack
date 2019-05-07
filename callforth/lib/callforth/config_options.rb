# frozen_string_literal: true

module Callforth
  class ConfigOptions
    class_attribute :enabled, default: true

    class_attribute :secret_key, default: -> { Rails.application.credentials.secret_key_base }
  end
end
