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
        return config.public_send(method_name) if config._options.include?(method_name)

        super
      end

      def respond_to_missing?(method_name, *)
        config._options.include?(method_name.to_sym) || super
      end
    end
  end
end
