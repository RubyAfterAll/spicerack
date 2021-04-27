# frozen_string_literal: true

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

      def class_pass_method(*methods)
        methods.each do |method|
          next if _class_pass_methods.include?(method)

          _class_pass_methods << method

          define_singleton_method method do |*args, **attrs|
            if RUBY_VERSION < "2.7.0" && attrs.empty?
              new(*args).public_send(method)
            else
              new(*args, **attrs).public_send(method)
            end
          end
        end
      end
    end
  end
end
