# frozen_string_literal: true

require "active_support"
require "active_support/callbacks"
require "active_support/inflector"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/module/delegation"

require "short_circu_it"

require "technologic/version"
require "technologic/event"
require "technologic/subscriber/base"
require "technologic/fatal_subscriber"
require "technologic/error_subscriber"
require "technologic/warn_subscriber"
require "technologic/info_subscriber"
require "technologic/debug_subscriber"
require "technologic/logger"

module Technologic
  extend ActiveSupport::Concern

  SEVERITIES = %i[debug info warn error fatal].freeze
  EXCEPTION_SEVERITIES = %i[error fatal].freeze

  included do
    delegate :instrument, :surveil, to: :class
    protected :instrument, :surveil

    SEVERITIES.each do |severity|
      delegate severity, to: :class
      protected severity # rubocop:disable Style/AccessModifierDeclarations
    end

    EXCEPTION_SEVERITIES.each do |severity|
      method_name = "#{severity}!"

      delegate method_name, to: :class
      protected method_name # rubocop:disable Style/AccessModifierDeclarations
    end
  end

  class_methods do
    def instrument(severity, event, **data, &block)
      ActiveSupport::Notifications.instrument("#{event}.#{name}.#{severity}", data, &block).tap do
        # If a block was defined, :instrument will return the value of the block.
        # Otherwise, :instrument will return nil, since it didn't do anything.
        # Returning true here allows us to do fun things like `info :subscription_created and return subscription`
        return true unless block_given?
      end
    end

    def surveil(event, severity: :info, **data, &block)
      raise LocalJumpError unless block_given?

      instrument(severity, "#{event}_started", **data)
      instrument(severity, "#{event}_finished", &block)
    end

    SEVERITIES.each do |severity|
      define_method(severity) { |event, **data, &block| instrument(severity, event, **data, &block) }
    end

    EXCEPTION_SEVERITIES.each do |severity|
      define_method("#{severity}!") do |error_class = StandardError, message = nil, **data, &block|
        instrument severity, error_class.name.demodulize, **data, &block
        raise error_class, message
      end
    end
  end
end
