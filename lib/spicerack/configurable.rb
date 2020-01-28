# frozen_string_literal: true

require "directive"

module Spicerack
  # Deprecation support for Directive cutover.
  module Configurable
    include Directive

    def configuration_options(*args)
      puts "DEPRECATION NOTICE: Spicerack::Configurable (used by #{self}) has been deprecated " \
           "and will be removed in Spicerack #{Gem::Version.new(VERSION).bump}. " \
           "Please use Directive instead."

      super(*args)
    end
  end
end
