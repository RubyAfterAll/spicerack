# frozen_string_literal: true

require "short_circu_it/version"
require "short_circu_it/errors"
require "short_circu_it/memoization_store"
require "active_support/core_ext/module"
require "active_support/core_ext/array"
require "active_support/concern"
require "around_the_world"

module ShortCircuIt
  extend ActiveSupport::Concern
  include AroundTheWorld

  PREPEND_MODULE_NAME = "MemoizedMethods"

  included do
    delegate :memoization_observers, to: :class
    delegate :clear_memoization, :clear_all_memoization, to: :memoization_store
  end

  private

  # @return [ShortCircuIt::MemoizationStore]
  def memoization_store
    @memoization_store ||= MemoizationStore.new(self)
  end

  class_methods do
    attr_internal_reader :memoization_observers

    protected

    # @example
    #   def expensive_method
    #     puts "doing some really expensive operation here!"
    #     "these datas are yuuge"
    #   end
    #   memoize :expensive_method
    #
    #   expensive_method
    #   doing some really expensive operation here!
    #   => "these datas are yuuge"
    #   expensive_method
    #   => "these datas are yuuge"
    #
    # @example
    #   def some_association
    #     SomeAssociation.find(some_association_id)
    #   end
    #   memoize :some_association, observes: :some_association_id
    #
    #   some_association_id = 1
    #   some_association
    #   * database stuff *
    #   => #<SomeAssociation:1234 id: 1>
    #
    #   some_association
    #   * no database stuff *
    #   => #<SomeAssociation:1234 id: 1>
    #
    #   some_association_id = 2
    #   some_association
    #   * database stuff *
    #   => #<SomeAssociation:2468 id: 2>
    #
    # @param method_name [Symbol] The name of the method to be memoized
    # @param :observes [Symbol, Array<Symbol>] A method or array of methods to be observed to determine memoization
    #                                          cache validity. If any of the observed values change, the cached
    #                                          value will be invalidated. By default, the object will observe itself.
    def memoize(method_name, observes: :itself)
      add_memoized_observers(method_name.to_sym, observes)

      around_method method_name.to_sym, PREPEND_MODULE_NAME do |*args|
        memoization_store.memoize(method_name.to_sym, args.hash) do
          super(*args)
        end
      end
    end

    private

    attr_internal_writer :memoization_observers

    def add_memoized_observers(method_name, observers)
      # TODO: Raise an error if method has already been memoized? A warning maybe?
      self.memoization_observers ||= {}
      self.memoization_observers = memoization_observers.
        merge(method_name.to_sym => Array.wrap(observers).freeze).
        freeze
    end
  end
end
