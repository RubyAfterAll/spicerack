# frozen_string_literal: true

module Technologic
  module Generators
    class InitializerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_initializer
        template "initializer.rb.erb", File.join("config/initializer/technologic.rb")
      end
    end
  end
end
