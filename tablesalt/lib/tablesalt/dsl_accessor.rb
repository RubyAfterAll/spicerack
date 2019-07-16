# frozen_string_literal: true

require "active_support/core_ext/module/attr_internal"

module Tablesalt
  module DSLAccessor
    extend ActiveSupport::Concern

    class_methods do
      def dsl_accessor(*accessors)
        accessors.each do |attr|
          define_singleton_method attr do |*args|
            raise ArgumentError, "wrong number of arguments (given #{args.size}, expected 1)" if args.size > 1

            ivar_name = attr_internal_ivar_name(attr)

            instance_variable_set(ivar_name, args.first) if args.size == 1

            instance_variable_get(ivar_name)
          end

          private_class_method attr

          define_method attr do
            instance_variable_get attr_internal_ivar_name(attr)
          end
        end
      end
    end
  end
end
