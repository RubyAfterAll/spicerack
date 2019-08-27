# frozen_string_literal: true

RSpec.shared_context "with an example facet" do
  subject(:example_facet) do
    example_facet_class.new(current_page: current_page, filter_by: filter_by, sort_by: sort_by)
  end

  let(:example_facet_class) { Class.new(Facet::Base) }

  let(:current_page) { 0 }
  let(:filter_by) { nil }
  let(:sort_by) { nil }
end
