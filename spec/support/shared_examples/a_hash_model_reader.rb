# frozen_string_literal: true

RSpec.shared_examples_for "a hash model reader" do |field|
  subject(:reader) { hash_model.public_send(field) }

  let(:data) { Hash[field, hash_value] }

  let(:expected_nil_value) { nil }
  let(:expected_invalid_value) { expected_nil_value }

  shared_examples_for "expected value is returned" do
    before { allow(hash_model).to receive(:write_attribute).and_call_original }

    it "assigns actual and returns expected" do
      expect(reader).to eq expected_value
      expect(hash_model).to have_received(:write_attribute).with(field, hash_value)
    end
  end

  context "when nil" do
    let(:hash_value) { nil }

    it { is_expected.to eq expected_nil_value }
  end

  context "when coercible" do
    let(:hash_value) { coercible_hash_value }

    it_behaves_like "expected value is returned"
  end

  context "when non-coercible" do
    let(:hash_value) { non_coercible_hash_value }
    let(:expected_value) { expected_invalid_value }

    it_behaves_like "expected value is returned"
  end

  context "when correct" do
    let(:hash_value) { correct_hash_value }

    it_behaves_like "expected value is returned"
  end
end
