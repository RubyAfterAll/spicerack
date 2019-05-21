# frozen_string_literal: true

RSpec.shared_examples_for "a hash model writer" do |field|
  subject(:writer) { hash_model.public_send("#{field}=".to_sym, given_value) }

  let(:data) { Hash[field, initial_value] }
  let(:expected_value) { given_value }
  let(:given_value) { double }

  shared_examples_for "field is set" do
    it "sets value" do
      expect { writer }.to change { data[field] }.from(initial_value).to(expected_value)
    end
  end

  context "without an initial value" do
    let(:initial_value) { nil }
    let(:data) do
      {}
    end

    it_behaves_like "field is set"
  end

  context "with initial value" do
    let(:initial_value) { double }

    it_behaves_like "field is set"
  end
end
