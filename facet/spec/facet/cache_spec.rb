# frozen_string_literal: true

RSpec.describe Facet::Cache, type: :concern do
  include_context "with an example facet"

  describe "#cache_key" do
    subject { example_facet.cache_key }

    let(:collection) { double }
    let(:expected_cache_key) { [ collection, current_page, filter_by, sort_by ] }

    before { allow(example_facet).to receive(:collection).and_return(collection) }

    context "with defaults" do
      let(:example_facet) { example_facet_class.new }

      it { is_expected.to eq expected_cache_key }
    end

    context "with arguments" do
      let(:current_page) { rand(1..2) }
      let(:filter_by) { Faker::Internet.domain_word.to_sym }
      let(:sort_by) { Faker::Internet.domain_word.to_sym }

      it { is_expected.to eq expected_cache_key }
    end
  end
end
