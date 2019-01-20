# frozen_string_literal: true

module AroundTheWorld
  class ProxyModule < Module
    attr_reader :purpose

    def initialize(purpose: nil, wrap_subclasses: false)
      @purpose = purpose unless purpose.blank?
      @wrap_subclasses = wrap_subclasses
    end

    def for?(purpose)
      return false if self.purpose.blank?

      self.purpose == purpose
    end

    def wraps_subclasses?
      wrap_subclasses.present?
    end

    def inspect
      "#<#{self.class.name}#{":#{purpose}" if purpose}>"
    end

    def defines_proxy_method?(method_name)
      instance_methods(true).include?(method_name.to_sym) || private_method_defined?(method_name.to_sym)
    end

    private

    attr_reader :wrap_subclasses
  end
end
