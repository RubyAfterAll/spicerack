# frozen_string_literal: true

RSpec.describe Tablesalt::ArrayIndex do
  subject(:array_index) { described_class.new(array) }

  let(:array) { Faker::Hipster.words }

  it { is_expected.to delegate_method(:[]).to(:index) }

  describe "#initialze" do
    subject { array_index.array }

    context "when the array is flat" do
      it { is_expected.not_to equal array }
      it { is_expected.to eq array }
    end

    context "when the array is nested" do
      let(:nested_array) { Faker::Hipster.words }
      let(:array) { [ nested_array ] }

      it "deep_dups the array" do
        expect(array_index.array).not_to equal array
        expect(array_index.array).to eq array

        expect(array_index.array[0]).not_to equal array[0]
        expect(array_index.array[0]).to eq array[0]
      end
    end
  end

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

  describe "#freeze" do
    before { array_index.freeze }

    it "freeze its attributes as well as itself" do
      expect(array_index.array).to be_frozen
      expect(array_index.index).to be_frozen
      expect(array_index).to be_frozen
    end
  end
end
