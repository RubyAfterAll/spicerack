# frozen_string_literal: true

RSpec.shared_examples_for "a task hash model" do
  describe "#started_at" do
    it_behaves_like "a hash model writer", :started_at
    it_behaves_like "a hash model predicate", :started_at do
      let(:hash_value) { Time.now.utc.round }
    end
    it_behaves_like "a hash model reader", :started_at do
      let(:expected_value) { Time.now.utc.round }
      let(:coercible_hash_value) { expected_value.to_s }
      let(:correct_hash_value) { expected_value }
      let(:non_coercible_hash_value) { "foo" }
    end
  end

  describe "#finished_at" do
    it_behaves_like "a hash model writer", :finished_at
    it_behaves_like "a hash model predicate", :finished_at do
      let(:hash_value) { Time.now.utc.round }
    end
    it_behaves_like "a hash model reader", :finished_at do
      let(:expected_value) { Time.now.utc.round }
      let(:coercible_hash_value) { expected_value.to_s }
      let(:correct_hash_value) { expected_value }
      let(:non_coercible_hash_value) { "foo" }
    end
  end
end
