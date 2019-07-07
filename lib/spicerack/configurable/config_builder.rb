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

      # TODO: Switch to this so we can dump __send__
      # NOTE: options must be set up before {#configure} is called
      # def options(&block)
      #   config_class.instance_exec(&block)
      # end

      # NOTE: options must be set up before {#configure} is called
      def option(*args)
        config_class.__send__(:option, *args)
      end

      def nested(*args, &block)
        config_class.__send__(:nested, *args, &block)
      end

      private

      def configuration
        @configuration ||= config_class.new
      end

      def config_class
        @config_class ||= Class.new(ConfigObject)
      end
    end
  end
end
