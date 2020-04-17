# frozen_string_literal: true

module Spicerack
  module Generators
    class StyleguideGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template ".rubocop.yml.erb", File.join(".rubocop.yml")
      end
    end
  end
end
