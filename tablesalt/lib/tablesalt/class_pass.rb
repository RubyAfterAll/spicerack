# frozen_string_literal: true

require "active_support/concern"

module Tablesalt
  module ClassPass
    extend ActiveSupport::Concern

    included do
      class_attribute :_class_pass_methods, instance_writer: false, default: []
    end

    class_methods do
      def inherited(base)
        base._class_pass_methods = _class_pass_methods.dup
        super
      end

      private

      def class_pass_method(*methods, to: nil)
        methods.each do |method|
          next if _class_pass_methods.include?(method)

          _class_pass_methods << method

          define_singleton_method method do |*args, **kwargs, &block|
            # TODO: remove this if branch when 2.7 support is removed
            if RUBY_VERSION < "3.0.0" && args.empty? && kwargs.empty?
              new.public_send(to || method, &block)
            else
              new(*args, **kwargs).public_send(to || method, &block)
            end
          end
        end
      end
    end
  end
end
