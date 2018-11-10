# frozen_string_literal: true

module AroundTheWorld
  class ProxyModule < Module
    attr_reader :purpose

    def initialize(purpose: nil)
      @purpose = purpose unless purpose.blank?
    end

    def for?(purpose)
      return false if self.purpose.blank?

      self.purpose == purpose
    end

    def inspect
      "#<#{self.class.name}#{" for: #{purpose.inspect}" if purpose}>"
    end
  end
end
