# frozen_string_literal: true

RSpec.describe Tablesalt::ArrayIndex do
  subject(:array_index) { described_class.new(array) }

  let(:array) { Faker::Hipster.words }

  it { is_expected.to delegate_method(:[]).to(:index) }

  describe "#index" do
    subject { array_index.index }

    let(:expected_hash) do
      array.each_with_index.each_with_object({}) do |(element, index), hash|
        hash[element] = index unless hash.key?(element)
      end
    end
  end

  describe "#[]" do
    subject { array_index[requested_item] }

    it "returns the index of each item in the array" do
      array.each_with_index do |element, index|
        expect(array_index[element]).to eq index
      end
    end

    context "when non-included items are queried" do
      let(:requested_item) { array.unshift }

      it { is_expected.to be_nil }
    end

    context "when the same item appears multiple times in the array" do
      let(:requested_item) { array.sample }
      let!(:repeated_item_index_before) { array.index(requested_item) }

      before { array << requested_item }

      it { is_expected.to eq repeated_item_index_before }
      it { is_expected.to eq array.index(requested_item) }
    end
  end
end
