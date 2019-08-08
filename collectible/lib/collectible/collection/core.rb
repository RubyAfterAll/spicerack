# frozen_string_literal: true

module Collectible
  module Collection
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :items

        delegate :name, to: :class, prefix: true
        delegate :to_a, :to_ary, :select, :map, :group_by, :partition, :as_json, to: :items
      end

      def initialize(*items)
        @items = items.flatten
      end

      def hash
        { class_name: class_name, items: items }.hash
      end

      # Merge and collection wrap
      # delegate :shift, :pop, :find, :index, :at, :[], :first, :last,
      #          :any?, :empty?, :present?, :blank?, :length, :count,
      #          :each, :reverse_each, :cycle, :uniq, :uniq!,
      #          :unshift, :insert, :prepend,
      #          :push, :<<, :concat, :+, :-,
      #          to: :items
      # def method_missing(method_name, *args, &block)
      #   if items.respond_to?(method_name)
      #     collection_wrap { items.public_send(method_name, *args, &block) }
      #   else
      #     super
      #   end
      # end

      private

      def respond_to_missing?(method_name, include_private = false)
        items.respond_to?(method_name, include_private) || super
      end
    end
  end
end
