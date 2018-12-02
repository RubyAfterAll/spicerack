# frozen_string_literal: true

module AroundTheWorld
  class MethodWrapper
    class << self
      # Passes arguments directly to {#new} - see docs
      def wrap(method_name, target, prevent_double_wrapping_for = false, &block)
        new(method_name, target, prevent_double_wrapping_for, &block).wrap
      end
    end

    attr_reader :method_name, :target, :prevent_double_wrapping_for, :block

    # @param method_name [String, Symbol] The name of the method to be wrapped.
    # @param target [Module] The class or module containing the method to be wrapped.
    # @param prevent_double_wrapping_for [String, Symbol]
    #   An identifier to define the proxy module's purpose in the ancestor tree.
    #   A method can only be wrapped once for a given purpose, though it can be wrapped
    #   again for other purposes, or for no given purpose.
    # @block The block that will be executed when the method is invoked.
    #        Should always call super, at least conditionally.
    def initialize(method_name, target, prevent_double_wrapping_for = false, &block)
      @method_name = method_name.to_sym
      @target = target
      @prevent_double_wrapping_for = prevent_double_wrapping_for
      @block = block
    end

    # Defines the wrapped method inside a proxy module and prepends the proxy module to the target module if necessary.
    def wrap
      ensure_method_defined!
      prevent_double_wrapping! if prevent_double_wrapping?

      define_proxy_method
      target.prepend proxy_module unless target.ancestors.include?(proxy_module)
    end

    private

    def ensure_method_defined!
      return if target.instance_methods(true).include?(method_name) || target.private_method_defined?(method_name)

      raise MethodNotDefinedError, "#{target} does not define :#{method_name}"
    end

    def prevent_double_wrapping!
      return unless proxy_module_for(prevent_double_wrapping_for)&.instance_methods&.include?(method_name)

      raise DoubleWrapError, "Module #{proxy_module} already defines the method :#{method_name}"
    end

    def define_proxy_method
      proxy_module.define_method(method_name, &block)

      proxy_module.instance_exec(method_name, method_privacy) do |method_name, method_privacy|
        case method_privacy
        when :protected
          protected method_name
        when :private
          private method_name
        end
      end
    end

    def method_privacy
      if target.protected_method_defined?(method_name)
        :protected
      elsif target.private_method_defined?(method_name)
        :private
      end
    end

    def prevent_double_wrapping?
      !prevent_double_wrapping_for.blank?
    end

    # @return [AroundTheWorld::ProxyModule] The proxy module upon which the method wrapper will be defined
    def proxy_module
      return @proxy_module ||= proxy_module_for(prevent_double_wrapping_for) if prevent_double_wrapping?

      @proxy_module ||= first_available_proxy_module || ProxyModule.new
    end

    # @param purpose [String, Symbol] An identifier to define the proxy module's purpose in the ancestor tree.
    # @return [AroundTheWorld::ProxyModule] Either an already-defined proxy module for the given purpose,
    #                                       or a new proxy module if one does not exist for the gibven purpose.
    def proxy_module_for(purpose)
      raise ArgumentError if purpose.blank?

      existing_proxy_modules.find { |proxy_module| proxy_module.for?(purpose) } ||
        ProxyModule.new(purpose: prevent_double_wrapping_for)
    end

    # @return [AroundTheWorld::ProxyModule] The first defined ProxyModule that does not define the method to be wrapped.
    # @return [NilClass] If all prepended ProxyModules already define the method,
    #                    or no ProxyModules have been prepended yet.
    def first_available_proxy_module
      existing_proxy_modules.reverse_each.find { |ancestor| !ancestor.instance_methods.include?(method_name) }
    end

    # @return [Array<AroundTheWorld::ProxyModule>] All ProxyModules +prepended+ to the target module.
    def existing_proxy_modules
      @existing_proxy_modules ||= target.ancestors.select.with_index do |ancestor, index|
        next if index >= base_ancestry_index

        ancestor.is_a? ProxyModule
      end
    end

    # @return [Integer] The index of the target module in its ancestry array
    def base_ancestry_index
      @base_ancestry_index = target.ancestors.index(target)
    end
  end
end
