# frozen_string_literal: true

require "rails/railtie"

module Callforth
  class Railtie < Rails::Railtie
    config.callforth = Callforth::ConfigOptions

    config.after_initialize do |application|
      if application.config.callforth.enabled
        Callforth::Setup.for(application)
      else
        Callforth::Setup.clear
      end
    end
  end
end
