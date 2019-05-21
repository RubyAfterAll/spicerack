# frozen_string_literal: true

RSpec.describe TaskHashModel, type: :integration do
  subject(:hash_model) { described_class.for(data) }

  let(:data) do
    {}
  end

  it { is_expected.to inherit_from Spicerack::HashModel }
  it { is_expected.to define_field :started_at, :datetime }
  it { is_expected.to define_field :finished_at, :datetime }

  describe "._fields" do
    subject { hash_model._fields }

    it { is_expected.to match_array %i[started_at finished_at] }
  end

  it_behaves_like "a task hash model"
end
