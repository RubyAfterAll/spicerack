# frozen_string_literal: true

module AroundTheWorld
  class ProxyModule < Module
    attr_reader :purpose

    # @param :purpose [*] Any string, symbol or object that signifies a purpose for the ProxyModule,
    #                     i.e. :memoization or SomeMemoizationGem.
    def initialize(purpose: nil)
      @purpose = purpose unless purpose.blank?
    end

    def for?(purpose)
      self.purpose == purpose
    end

    def inspect
      "#<#{self.class.name}#{":#{purpose}" if purpose}>"
    end

    # @return [Boolean] True if the ProxyModule defines aa method of the given name, regardless of its privacy.
    def defines_proxy_method?(method_name)
      instance_methods(true).include?(method_name.to_sym) || private_method_defined?(method_name.to_sym)
    end
  end
end
