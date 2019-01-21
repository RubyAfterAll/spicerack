# frozen_string_literal: true

require "active_support/core_ext/array"
require_relative "method_wrapper/proxy_creation"

module AroundTheWorld
  class Rewrapper
    include MethodWrapper::ProxyCreation

    private_class_method :new

    class << self
      # Passes arguments directly to {#new} - see {#initialize} for full docs
      def rewrap(target, proxy_modules)
        new(target, proxy_modules).rewrap
      end
    end

    attr_reader :target, :proxy_modules

    # @param target [Module] The class or module containing the method to be wrapped.
    # @param proxy_modules [AroundTheWorld::ProxyModule, Array<AroundTheWorld::ProxyModule>]
    #   A single ProxyModule or an array of ProxyModules to be prepended to the given target.
    def initialize(target, proxy_modules)
      @target = target
      @proxy_modules = Array.wrap(proxy_modules)

      invalid_modules = self.proxy_modules.reject { |mod| mod.is_a?(ProxyModule) }
      raise TypeError, "not a ProxyModule: #{invalid_modules.map(&:inspect).join(", ")}" if invalid_modules.any?
    end

    # Prepends the given ProxyModule(s) to the target
    def rewrap
      proxy_modules.each do |mod|
        next if existing_proxy_modules(target).include?(mod)

        target.prepend mod
      end
    end
  end
end
