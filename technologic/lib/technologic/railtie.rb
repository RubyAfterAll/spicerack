# frozen_string_literal: true

require "rails/railtie"

module Technologic
  class Railtie < Rails::Railtie
    config.technologic = Technologic::ConfigOptions

    config.after_initialize do |application|
      Technologic::Setup.for(application) if application.config.technologic.enabled
    end
  end
end
