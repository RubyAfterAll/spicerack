# frozen_string_literal: true

RSpec.describe Tablesalt::ArrayIndex do
  subject(:array_index) { described_class.new(array) }

  let(:array) { Faker::Hipster.words }

  it { is_expected.to delegate_method(:[]).to(:index) }

  describe "#index" do
    it "returns the index of each item in the array" do
      array.each_with_index do |element, index|
        expect(array_index[element]).to eq index
      end
    end

    context "when non-included items are queried" do
      let(:requested_item) { array.unshift }

      it "returns nil for items not in the array" do
        expect(array_index[requested_item]).to be_nil
      end
    end
  end
end
