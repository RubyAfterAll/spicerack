# frozen_string_literal: true

require "active_support/core_ext/module"

module ShortCircuIt
  class MemoizationStore
    delegate :memoization_observers, to: :owner

    # @param owner [*] The object being memoized
    def initialize(owner)
      @owner = owner
    end

    # @param method_name [Symbol] The name of the method being memoized.
    # @param argument_hash [Integer] The hash value of the arguments passed to the method.
    # @yield [] Yields to a given block with no arguments. Memoizes the value returned by the block.
    # @return [*] The value returned either from the memoization cache if present, or yielded block if not.
    def memoize(method_name, argument_hash)
      return memoized_value(method_name, argument_hash) if memoized?(method_name, argument_hash)

      clear_memoization(method_name) unless current_memoization_for_method?(method_name)

      yield.tap do |returned_value|
        current_memoization_for_method(method_name)[argument_hash] = returned_value
      end
    end

    # Clears all cached values for the given method
    #
    # @param method_name [Symbol] The name of a memoized method
    # @return [Boolean] True if a value was cleared, false if not
    def clear_memoization(method_name)
      !!memoized_hash.delete(method_name)
    end

    # Clears all memoized values on the object
    def clear_all_memoization
      memoized_hash.clear
    end

    def inspect
      "#<#{self.class} memoized: #{memoized_hash.keys.inspect}>"
    end

    private

    def memoized_hash
      @memoized_hash ||= {}
    end

    def memoization_for_method(method_name)
      memoized_hash[method_name] ||= {}
    end

    # @param method_name [Symbol] The name of the method to memoize
    # @param argument_hash [Integer] The hash value of the arguments passed to the method
    # @return [Boolean] True if the method has a current memoized value with the given arguments
    def memoized?(method_name, argument_hash)
      current_memoization_for_method?(method_name) && current_memoization_for_method(method_name).key?(argument_hash)
    end

    # @param method_name [String] The name of the method to memoize
    # @param argument_hash [Integer] The hash value of the arguments passed to the method
    # @return [*] The value that has been memoized for the method/argument combination
    def memoized_value(method_name, argument_hash)
      raise NotMemoizedError unless memoized?(method_name, argument_hash)

      current_memoization_for_method(method_name)[argument_hash]
    end

    # @param method_name [Symbol] The name of a memoized method
    # @return [Hash] A hash of memoized values for the current state of the observed objects for the given method.
    def current_memoization_for_method(method_name)
      memoization_for_method(method_name)[state_hash(method_name)] ||= {}
    end

    # @param method_name [Symbol] The name of a memoized method
    # @return [Boolean] True if there are any memoized values for the current state of the observed objects.
    def current_memoization_for_method?(method_name)
      memoization_for_method(method_name).key?(state_hash(method_name))
    end

    # @param method_name [Symbol] The name of a memoized method
    # @return [Integer] The hash value of all observed objects for the given method.
    def state_hash(method_name)
      memoization_observers[method_name].map { |observed_method| owner.public_send(observed_method) }.hash
    end

    attr_reader :owner
  end
end
