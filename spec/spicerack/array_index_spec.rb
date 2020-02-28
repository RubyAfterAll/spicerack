# frozen_string_literal: true

RSpec.describe Spicerack::ArrayIndex do
  subject(:array_index) { described_class.new(*input) }

  let(:input) { [ array ] }
  let(:array) { Faker::Hipster.words.uniq }

  it { is_expected.to delegate_method(:[]).to(:index) }

  it { is_expected.to delegate_method(:to_ary).to(:array) }
  it { is_expected.to delegate_method(:<<).to(:array) }
  it { is_expected.to delegate_method(:push).to(:array) }
  it { is_expected.to delegate_method(:unshift).to(:array) }
  it { is_expected.to delegate_method(:concat).to(:array) }

  describe "#initialze" do
    subject { array_index.array }

    it { is_expected.to eq array }
  end

  describe "#index" do
    subject(:index) { array_index.index }

    let(:expected_hash) do
      array.each_with_index.each_with_object({}) do |(element, index), hash|
        hash[element] = index unless hash.key?(element)
      end
    end

    it { is_expected.to eq expected_hash }

    it "memoizes the index" do
      expect(index).to equal array_index.index
    end

    context "when the source array changes" do
      let!(:index_before) { array_index.index }
      let(:new_value) { rand }

      before { array_index << new_value }

      it "resets the index" do
        expect(index_before).not_to equal array_index.index
        expect(array_index[new_value]).to eq array_index.array.index(new_value)
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

      before { array_index << requested_item }

      it { is_expected.to eq repeated_item_index_before }
      it { is_expected.to eq array.index(requested_item) }
    end
  end

  describe "#freeze" do
    before { array_index.freeze }

    it "deep_dups the array" do
      expect(array_index.array).not_to equal array
      expect(array_index.array).to eq array
    end

    it "freeze its attributes as well as itself" do
      expect(array_index.array).to be_frozen
      expect(array_index.index).to be_frozen
      expect(array_index).to be_frozen
      expect(array_index.index).to eq described_class[array].index
    end

    context "when the source array changes" do
      subject { array_index.array }

      let(:new_value) { rand }

      it "raises" do
        expect { array_index.array << new_value }.to raise_error(FrozenError)
      end
    end
  end
end
