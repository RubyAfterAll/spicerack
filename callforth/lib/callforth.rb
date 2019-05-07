# frozen_string_literal: true

require "active_support"
require "active_support/callbacks"

require "callforth/version"
require "callforth/encoder"
require "callforth/config_options"
require "callforth/setup"

module Callforth
  mattr_accessor :secret_key

  class << self
    def encode(*arguments)
      Callforth::Encoder.new(*arguments).encode
    end
  end
end

require "callforth/railtie" if defined?(Rails)
