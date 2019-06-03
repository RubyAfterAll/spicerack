# frozen_string_literal: true

require_relative "configurable/config"

module Spicerack
  module Configurable
    extend ActiveSupport::Concern

    class_methods do
      def configure
        yield config
      end

      def option(name, *args)
        delegate name, to: :config

        config_class.__send__(:option, name, *args)
      end

      private

      def config_class
        @config_class ||= Class.new(Config)
      end

      def config
        @config ||= config_class.new
      end
    end
  end
end
