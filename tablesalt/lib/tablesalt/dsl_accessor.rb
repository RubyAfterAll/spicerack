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

      # @param *accessors [Array<String, Symbol>] A list of dsl accessor attributes to define
      # @param :instance_reader [Boolean] If true, a reader method is defined on the instance. Default: false
      def dsl_accessor(*accessors, **options)
        accessors.each do |attr|
          _define_dsl_accessor(attr)
          _define_instance_reader(attr) if options[:instance_reader]
        end
      end

      def _define_dsl_accessor(attr)
        ivar_name = attr_internal_ivar_name(attr)

        define_singleton_method attr do |*args|
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

      def _define_instance_reader(attr)
        ivar_name = attr_internal_ivar_name(attr)
        define_method attr do
          self.class.instance_variable_get(ivar_name)
        end
      end
    end
  end
end
