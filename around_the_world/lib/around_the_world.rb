# frozen_string_literal: true

require_relative "around_the_world/errors"
require_relative "around_the_world/method_wrapper"
require_relative "around_the_world/proxy_module"
require_relative "around_the_world/version"
require "active_support/concern"
require "active_support/core_ext/object/blank"
require "active_support/descendants_tracker"

module AroundTheWorld
  extend ActiveSupport::Concern

  included do
    singleton_class.extend(AroundTheWorld::ClassMethods)
  end

  module ClassMethods
    protected

    # Defines a method that gets called +around+ the given instance method.
    #
    # @example
    #   class SomeClass
    #     around_method :dont_look_in_here do |*args|
    #       things_happened = super(*args)
    #
    #       if things_happened
    #         "Something happened!"
    #       else
    #         "Nothing to see here..."
    #       end
    #     end
    #
    #     def dont_look_in_here
    #       do_some_things
    #     end
    #   end
    #
    #   SomeClass.new.dont_look_in_here
    #   => "Something happened!"
    #
    # @example
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do |*args|
    #     @memoized ||= super(*args)
    #   end
    #
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do |*args|
    #     @memoized ||= super(*args)
    #   end
    #   # => AroundTheWorld::DoubleWrapError:
    #          "Module AroundTheWorld:ProxyModule:memoization already defines the method :dont_look_in_here"
    #
    #   around_method :dont_look_in_here do |*args|
    #     do_something_else
    #     super(*args)
    #   end
    #   # => no error raised
    #
    # @example
    #   class SomeClass
    #     include AroundTheWorld
    #
    #     class << self
    #       def a_singleton_method; end
    #
    #       around_method :a_singleton_method do |*args|
    #         super(*args)
    #         "It works for class methods too!"
    #       end
    #     end
    #   end
    #
    #   SomeClass.a_singleton_method
    #   => "It works for class methods too!"
    #
    # @api public
    # @param method_name [Symbol]
    # @param :prevent_double_wrapping_for [Object]
    #   If defined, this prevents wrapping the method twice for a given purpose. Accepts any argument.
    def around_method(method_name, prevent_double_wrapping_for: nil, &block)
      MethodWrapper.wrap(
        method_name: method_name,
        target: self,
        prevent_double_wrapping_for: prevent_double_wrapping_for,
        &block
      )
    end
  end
end
