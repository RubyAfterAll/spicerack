# frozen_string_literal: true

module Spicerack
  module Configurable
    class Reader
      def initialize(config)
        @config = config
      end

      private

      attr_reader :config

      def method_missing(method_name, *)
        name = method_name.to_sym

        return config.public_send(name) if config._options.map(&:to_sym).include?(name)
        return config._nested_builders[name].reader if config._nested_builders.key?(name)

        super
      end

      def respond_to_missing?(method_name, *)
        config._options.map(&:to_sym).include?(method_name.to_sym) || super
      end
    end
  end
end
