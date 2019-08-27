# frozen_string_literal: true

RSpec.describe Facet::Core do
  include_context "with an example facet"

  describe "#initialize" do
    context "with no arguments" do
      subject(:example_facet) { example_facet_class.new }

      it "uses defaults" do
        expect(example_facet.current_page).to eq 0
        expect(example_facet.filter_by).to be_nil
        expect(example_facet.sort_by).to be_nil
      end
    end

    context "with arguments" do
      let(:current_page) { rand(1..2) }
      let(:filter_by) { Faker::Internet.domain_word.to_sym }
      let(:sort_by) { Faker::Internet.domain_word.to_sym }

      it "uses arguments" do
        expect(example_facet.current_page).to eq current_page
        expect(example_facet.filter_by).to eq filter_by
        expect(example_facet.sort_by).to eq sort_by
      end
    end
  end
end
