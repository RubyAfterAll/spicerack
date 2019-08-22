# frozen_string_literal: true

require "active_support/core_ext/module/attr_internal"

# Utility for creating DSL class variables - great for base classes with many child classes.
#
# class Vehicle
#   include Tablesalt::DSLAccessor
#
#   dsl_accessor :this_many_wheels
#
#   def self.inspect
#     "I have #{this_many_wheels} wheels"
#   end
# end
#
# class Car < Vehicle
#   this_many_wheels 4
# end
#
# class Motorcycle < Vehicle
#   this_many_wheels 2
# end
#
# class Semi < Vehicle
#   this_many_wheels 18
# end
#
# Car.inspect
# => "I have 4 wheels"
#
# Motorcycle.inspect
# => "I have 2 wheels"
#
# Semi.inspect
# => "I have 18 wheels"
#
module Tablesalt
  module DSLAccessor
    extend ActiveSupport::Concern

    class_methods do
      private

      def dsl_accessor(*accessors)
        accessors.each { |attr| _define_dsl_accessor(attr) }
      end

      def _define_dsl_accessor(attr)
        define_singleton_method attr do |*args|
          ivar_name = attr_internal_ivar_name(attr)

          if instance_variable_defined?(ivar_name)
            raise NameError, "internal attribute #{attr} already set" if args.one?
            raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 0)" if args.size > 1

            instance_variable_get(ivar_name)
          else
            raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1)" unless args.one?

            instance_variable_set(ivar_name, args.first)
          end
        end

        private_class_method attr
      end
    end
  end
end
