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
            expected_argument_count = instance_variable_defined?(ivar_name) ? 0 : 1

            if args.size > expected_argument_count
              raise NameError, "internal attribute #{attr} already set" if args.one?

              raise ArgumentError, "wrong number of arguments (given #{args.size}, expected #{expected_argument_count})"
            end

            if instance_variable_defined?(ivar_name)
              instance_variable_get(ivar_name)
            else
              raise ArgumentError, "wrong number of arguments (given #{args.size}, expected #{expected_argument_count})" if args.none?

              instance_variable_set(ivar_name, args.first) if args.size
            end
          end

          private_class_method attr
        end
      end
    end
  end
end
