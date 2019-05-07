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
    def encode(klass, method, class_arguments: nil, method_arguments: nil)
      Callforth::Encoder.new(klass, method, class_arguments: class_arguments, method_arguments: method_arguments)
    end
  end
end

require "callforth/railtie" if defined?(Rails)
