# frozen_string_literal: true

module Spicerack
  module Configurable
    class ConfigBuilder
      def reader
        @reader ||= Reader.new(configuration)
      end

      def configure
        yield configuration
      end

      def option(*args)
        config_class.__send__(:option, *args)
      end

      private

      def configuration
        @configuration ||= config_class.new
      end

      def config_class
        @config_class ||= Class.new(InputObject)
      end
    end
  end
end
