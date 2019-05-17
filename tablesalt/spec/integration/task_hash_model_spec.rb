# frozen_string_literal: true

RSpec.describe TaskHashModel, type: :integration do
  subject(:hash_model) { described_class.for(hash) }

  let(:hash) do
    {}
  end

  it { is_expected.to inherit_from Tablesalt::HashModel }

  describe "._fields" do
    subject { hash_model._fields }

    it { is_expected.to match_array %i[started_at finished_at] }
  end

  it_behaves_like "a task hash model"
end
