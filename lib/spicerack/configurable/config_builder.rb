# frozen_string_literal: true

require "technologic"

module Spicerack
  module Configurable
    class ConfigBuilder
      include Technologic

      delegate :config_eval, to: :reader

      def reader
        @reader ||= Reader.new(configuration)
      end

      def configure
        # note to self: on second thought, add the callbacks first then do this in a concern
        warn_on_multiple_configure_calls

        mutex.synchronize do
          yield configuration
        end
      end

      # NOTE: options must be set up before {#configure} is called
      def option(*args, &block)
        config_class.__send__(:option, *args, &block)
      end

      def nested(*args, &block)
        config_class.__send__(:nested, *args, &block)
      end

      private

      attr_writer :configure_called

      def configuration
        config_class.instance
      end

      def config_class
        @config_class ||= Class.new(ConfigObject)
      end

      def mutex
        @mutex = Mutex.new
      end

      def configure_called?
        @configure_called
      end

      def warn_on_multiple_configure_calls
        warn <<~WARNING
          Spicerack::Configurable.configure has been called more than once, which can lead to unexpected consequences.
          For the most predictable behavior, configure should only be called once per library.
        WARNING
      end
    end
  end
end
