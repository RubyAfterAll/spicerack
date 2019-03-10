# frozen_string_literal: true

require_relative "method_wrapper/proxy_creation"

module AroundTheWorld
  class MethodWrapper
    include ProxyCreation

    private_class_method :new

    class << self
      # Passes arguments directly to {#new} - see {#initialize} for full docs
      def wrap(**args, &block)
        new(**args, &block).wrap
      end
    end

    attr_reader :method_name, :target

    # @param :method_name [String, Symbol] The name of the method to be wrapped.
    # @param :target [Module] The class or module containing the method to be wrapped.
    # @param :prevent_double_wrapping_for [String, Symbol]
    #   An identifier to define the proxy module's purpose in the ancestor tree.
    #   A method can only be wrapped once for a given purpose, though it can be wrapped
    #   again for other purposes, or for no given purpose.
    # @block The block that will be executed when the method is invoked.
    #        Should always call super, at least conditionally.
    def initialize(method_name:, target:, prevent_double_wrapping_for: nil, &block)
      raise TypeError, "target must be a module or a class" unless target.is_a?(Module)

      @method_name = method_name.to_sym
      @target = target
      @prevent_double_wrapping_for = prevent_double_wrapping_for || nil
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

    attr_reader :prevent_double_wrapping_for, :block

    def prevent_double_wrapping?
      prevent_double_wrapping_for.present?
    end

    def ensure_method_defined!
      return if target.instance_methods(true).include?(method_name) || target.private_method_defined?(method_name)

      raise MethodNotDefinedError, "#{target} does not define :#{method_name}"
    end

    def prevent_double_wrapping!
      return unless already_wrapped?(method_name, target, prevent_double_wrapping_for)

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

    # @return [AroundTheWorld::ProxyModule] The proxy module upon which the method wrapper will be defined
    def proxy_module
      @proxy_module ||= proxy_module_with_purpose(method_name, target, prevent_double_wrapping_for)
    end
  end
end
