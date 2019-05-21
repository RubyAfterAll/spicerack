# frozen_string_literal: true

RSpec.shared_examples_for "a hash model predicate" do |field|
  subject(:predicate) { hash_model.public_send("#{field}?".to_sym) }

  let(:data) { Hash[field, hash_value] }

  let(:expected_value) { false }

  context "when nil" do
    let(:hash_value) { nil }

    it { is_expected.to eq expected_value }
  end

  context "when set" do
    let(:expected_value) { true }

    it { is_expected.to eq expected_value }
  end
end
