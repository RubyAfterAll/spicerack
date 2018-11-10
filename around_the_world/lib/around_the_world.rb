# frozen_string_literal: true

require_relative "around_the_world/errors"
require_relative "around_the_world/method_wrapper"
require_relative "around_the_world/proxy_module"
require_relative "around_the_world/version"
require "active_support/concern"

module AroundTheWorld
  extend ActiveSupport::Concern

  class_methods do
    protected

    # Defines a method that gets called +around+ the given instance method.
    #
    # @example
    #   class SomeClass
    #     around_method :dont_look_in_here, "DoesAThing" do
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
    # @param method_name [Symbol]
    # @param proxy_module_name [String] The camelized name of a custom module to place the wrapper method in.
    #                                   This is necessary to enable wrapping a single method more than once
    #                                   since a module cannot super to itself.
    #                                   It's recommended to name the module after what the method wrapper will do,
    #                                   for example LogsAnEvent for a wrapper method that logs something.
    #                                   Because of the potential for overriding previously wrapped methods, this
    #                                   parameter is required.
    def around_method(method_name, proxy_module_name = nil, prevent_double_wrapping_for: nil, &block)
      MethodWrapper.wrap(method_name, self, prevent_double_wrapping_for, &block)
    end
  end
end
