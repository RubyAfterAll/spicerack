# frozen_string_literal: true

module Collectible
  module Collection
    module WrapsCollectionMethods
      extend ActiveSupport::Concern

      PROXY_MODULE_NAME = "WrapCollectionMethods"

      included do
        collection_wrap_on :collection_wrap, :select
        collection_wrap_values_on :group_by, :partition
      end

      protected

      def collection_wrap
        yield
      end

      class_methods do
        protected # rubocop:disable Lint/UselessAccessModifier

        def collection_wrap_on(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: PROXY_MODULE_NAME) do |*args, &block|
              result = super(*args, &block)

              return self if result.equal?(items)

              result.is_a?(Array) ? self.class.new(result) : result
            end
          end
        end

        def collection_wrap_values_on(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: PROXY_MODULE_NAME) do |*args, &block|
              result = super(*args, &block)

              if result.respond_to?(:transform_values)
                result.transform_values { |collection| collection_wrap { collection } }
              elsif result.respond_to?(:map)
                result.map { |collection| collection_wrap { collection } }
              else
                collection_wrap { result }
              end
            end
          end
        end
      end
    end
  end
end
