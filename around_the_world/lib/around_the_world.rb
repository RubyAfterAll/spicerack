# frozen_string_literal: true

require_relative "around_the_world/errors"
require_relative "around_the_world/method_wrapper"
require_relative "around_the_world/rewrapper"
require_relative "around_the_world/proxy_module"
require_relative "around_the_world/version"
require "active_support/concern"
require "active_support/descendants_tracker"

module AroundTheWorld
  extend ActiveSupport::Concern

  included do
    extend ActiveSupport::DescendantsTracker
  end

  class_methods do
    protected

    # Defines a method that gets called +around+ the given instance method.
    #
    # @example
    #   class SomeClass
    #     around_method :dont_look_in_here do
    #       things_happened = super
    #
    #       if things_happened
    #         puts "Something happened!"
    #       else
    #         puts "Nothing to see here..."
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
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do
    #     @memoized ||= super
    #   end
    #
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do
    #     @memoized ||= super
    #   end
    #   # => AroundTheWorld::DoubleWrapError:
    #          "Module AroundTheWorld:ProxyModule:memoization already defines the method :dont_look_in_here"
    #
    #   around_method :dont_look_in_here do
    #     do_something_else
    #     super
    #   end
    #   # => no error raised
    #
    # @param method_name [Symbol]
    # @param :prevent_double_wrapping_for [Object]
    #   If defined, this prevents wrapping the method twice for a given purpose. Accepts any argument.
    # @param :wrap_subclasses [Boolean]
    #   If true, the given method will still be wrapped by the given block in subclasses that override the given method.
    #   If false, subclasses that override the method will also override the wrapping block.
    #   Default: false
    def around_method(method_name, prevent_double_wrapping_for: nil, wrap_subclasses: false, &block)
      MethodWrapper.wrap(
        method_name: method_name,
        target: self,
        prevent_double_wrapping_for: prevent_double_wrapping_for,
        wrap_subclasses: wrap_subclasses,
        &block
      )

      descendants.each { |child| Rewrapper.rewrap(child, proxy_modules_for_subwrapping) }
    end

    def inherited(child)
      super(child)

      Rewrapper.rewrap(child, proxy_modules_for_subwrapping)
    end

    private

    def proxy_modules_for_subwrapping
      ancestors.select { |mod| mod.is_a?(ProxyModule) && self < mod && mod.wraps_subclasses? }
    end
  end
end
