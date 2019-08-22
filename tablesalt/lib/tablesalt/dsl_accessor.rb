# frozen_string_literal: true

require "active_support/core_ext/module/attr_internal"

module Tablesalt
  module DSLAccessor
    extend ActiveSupport::Concern
    include Technologic

    class_methods do
      private

      def dsl_accessor(*accessors)
        accessors.each do |attr|
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
end
