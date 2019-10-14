# frozen_string_literal: true

RSpec.shared_context "with an example facet" do
  subject(:example_facet) do
    example_facet_class.new(
      current_page: current_page,
      filter_by: filter_by,
      sort_by: sort_by,
      all: all,
      paginate: paginate,
      source: source,
    )
  end

  let(:example_facet_class) { Class.new(Facet::Base) }
  let(:example_facet_root_name) { Faker::Internet.domain_word.capitalize }
  let(:example_facet_name) { "#{example_facet_root_name}Facet" }

  let(:current_page) { 1 }
  let(:filter_by) { nil }
  let(:sort_by) { nil }
  let(:all) { false }
  let(:paginate) { true }
  let(:source) { nil }

  before { stub_const(example_facet_name, example_facet_class) }
end
