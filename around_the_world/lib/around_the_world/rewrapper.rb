# frozen_string_literal: true

require "active_support/core_ext/array"
require_relative "method_wrapper/proxy_creation"

module AroundTheWorld
  class Rewrapper
    include MethodWrapper::ProxyCreation

    private_class_method :new

    class << self
      def rewrap(target, proxy_modules)
        new(target, proxy_modules).rewrap
      end
    end

    attr_reader :target, :proxy_modules

    def initialize(target, proxy_modules)
      @target = target
      @proxy_modules = Array.wrap(proxy_modules)
    end

    def rewrap
      proxy_modules.each do |mod|
        next if existing_proxy_modules(target).include?(mod)

        target.prepend mod
      end
    end
  end
end
