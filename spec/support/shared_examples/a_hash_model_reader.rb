# frozen_string_literal: true

RSpec.shared_examples_for "a hash model reader" do |field|
  subject(:reader) { hash_model.public_send(field) }

  let(:data) { Hash[field, hash_value] }

  let(:expected_nil_value) { nil }
  let(:expected_invalid_value) { expected_nil_value }

  context "when nil" do
    let(:hash_value) { nil }

    it { is_expected.to eq expected_nil_value }
  end
end
