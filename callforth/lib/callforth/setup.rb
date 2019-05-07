# frozen_string_literal: true

module Callforth
  class Setup
    class << self
      def for(application)
        callforth_config = application.config.callforth

        setup_secret_key(callforth_config)
      end

      def clear
        clear_secret_key
      end

      private

      def setup_secret_key(config)
        Callforth.secret_key = config.secret_key.respond_to?(:call) ? config.secret_key.call : config.secret_key
      end

      def clear_secret_key
        Callforth.secret_key = nil
      end
    end
  end
end
