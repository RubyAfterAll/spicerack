# frozen_string_literal: true

module Facet
  module Generators
    class FacetGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      hook_for :test_framework

      def create_facet
        template "facet.rb.erb", File.join("app/facets/", class_path, "#{file_name}_facet.rb")
      end
    end
  end
end
