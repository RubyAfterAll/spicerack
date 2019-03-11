# frozen_string_literal: true

module AroundTheWorld
  class MethodWrapper
    module ProxyCreation
      private

      # @return [Boolean] Returns true if the method has beeen wrapped for the given purpose,
      #                   whether or not that wrapper applies to subclassed methods.
      def already_wrapped?(method_name, target, purpose)
        existing_proxy_modules(target).any? { |mod| mod.for?(purpose) && mod.defines_proxy_method?(method_name) }
      end

      # @return [AroundTheWorld::ProxyModule] Either an already-defined proxy module for the given purpose,
      #                                       or a new proxy module if one does not exist for the given purpose.
      def proxy_module_with_purpose(method_name, target, purpose)
        existing_proxy_module_with_purpose(method_name, target, purpose) ||
          ProxyModule.new(purpose: purpose)
      end

      def existing_proxy_module_with_purpose(method_name, target, purpose)
        existing_proxy_modules(target).reverse_each.find do |ancestor|
          ancestor.for?(purpose) && !ancestor.defines_proxy_method?(method_name)
        end
      end

      # @return [Array<AroundTheWorld::ProxyModule>] All ProxyModules +prepended+ to the target module.
      def existing_proxy_modules(target)
        target_ancestry_index = base_ancestry_index(target)

        @existing_proxy_modules ||= {}
        @existing_proxy_modules[target] ||= target.ancestors.select.with_index do |ancestor, index|
          next if index >= target_ancestry_index

          ancestor.is_a? ProxyModule
        end
      end

      # @return [Integer] The index of the target module in its ancestry array
      def base_ancestry_index(target)
        target.ancestors.index(target)
      end
    end
  end
end
