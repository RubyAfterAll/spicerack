# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/object/blank"
require "active_support/descendants_tracker"

require_relative "around_the_world/errors"
require_relative "around_the_world/method_wrapper"
require_relative "around_the_world/proxy_module"
require_relative "around_the_world/version"

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
    #     around_method :make_something_happen!, :did_something_happened? do |...|
    #       things_happened = super(...)

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
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do |...|
    #     @memoized ||= super(...)
    #   end
    #
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do |...|
    #     @memoized ||= super(...)
    #   end
    #   # => AroundTheWorld::DoubleWrapError:
    #          "Module AroundTheWorld:ProxyModule:memoization already defines the method :dont_look_in_here"
    #
    #   around_method :dont_look_in_here do |...|
    #     do_something_else
    #     super(...)
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
    #       around_method :a_singleton_method do |...|
    #         super(...)
    #         "It works for class methods too!"
    #       end
    #     end
    #   end
    #
    #   SomeClass.a_singleton_method
    #   => "It works for class methods too!"
    #
    # @api public
    # @param method_names [Array<Symbol, String>] A list of methods to be wrapped
    # @param :prevent_double_wrapping_for [Object]
    #   If defined, this prevents wrapping the method twice for a given purpose. Accepts any argument.
    # @param :allow_undefined_method [Boolean] When false, an error is raised if the wrapped method is not
    #   explicitly defined by the target module or class. Default: false
    def around_method(*method_names, prevent_double_wrapping_for: nil, allow_undefined_method: false, &block)
      method_names.each do |method_name|
        MethodWrapper.wrap(
          method_name: method_name,
          target: self,
          prevent_double_wrapping_for: prevent_double_wrapping_for,
          allow_undefined_method: allow_undefined_method,
          &block
        )
      end
    end
  end
end
