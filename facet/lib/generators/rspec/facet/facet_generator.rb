# frozen_string_literal: true

module Rspec
  module Generators
    class FacetGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_spec_file
        template "facet_spec.rb.erb", File.join("spec/facets/", class_path, "#{file_name}_facet_spec.rb")
      end
    end
  end
end
