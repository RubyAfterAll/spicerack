# frozen_string_literal: true

require_relative "configurable/config"

module Spicerack
  module Configurable
    extend ActiveSupport::Concern
    include ActiveSupport::Callbacks

    class_methods do
      def configure
        yield config
      end

      def option(name, *args)
        attr_reader name

        config.option(name, *args)
      end

      private

      def config
        @config ||= Config.new
      end
    end
  end
end
