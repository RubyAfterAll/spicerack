# frozen_string_literal: true

RSpec.describe ExampleHashModel, type: :integration do
  subject(:hash_model) { described_class.for(data) }

  let(:data) do
    {}
  end

  it { is_expected.to inherit_from ExampleHashModelParent }
  it { is_expected.to inherit_from Spicerack::HashModel }
  it { is_expected.to define_field :started_at, :datetime }
  it { is_expected.to define_field :finished_at, :datetime }
  it { is_expected.to define_field :count, :integer, default: 42 }
  it { is_expected.to define_field :rate, :float, default: 3.14 }

  describe "._fields" do
    subject { hash_model._fields }

    it { is_expected.to match_array %i[started_at finished_at count rate] }
  end

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

  describe "#count" do
    it_behaves_like "a hash model writer", :count
    it_behaves_like "a hash model predicate", :count do
      let(:hash_value) { rand(1..10) }
    end
    it_behaves_like "a hash model reader", :count do
      let(:expected_value) { rand(1..10) }
      let(:coercible_hash_value) { expected_value.to_s }
      let(:correct_hash_value) { expected_value }
      let(:non_coercible_hash_value) { "foo" }
      let(:expected_nil_value) { 42 }
      let(:expected_invalid_value) { 0 }
    end
  end

  describe "#rate" do
    it_behaves_like "a hash model writer", :rate
    it_behaves_like "a hash model predicate", :rate do
      let(:hash_value) { rand }
    end
    it_behaves_like "a hash model reader", :rate do
      let(:expected_value) { rand }
      let(:coercible_hash_value) { expected_value.to_s }
      let(:correct_hash_value) { expected_value }
      let(:non_coercible_hash_value) { "foo" }
      let(:expected_nil_value) { 3.14 }
      let(:expected_invalid_value) { 0.0 }
    end
  end
end
