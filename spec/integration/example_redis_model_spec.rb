# frozen_string_literal: true

RSpec.describe ExampleRedisModel, type: :integration do
  subject(:redis_model) { described_class.new }

  it { is_expected.to inherit_from Spicerack::RedisModel }
  it { is_expected.to include_module Spicerack::HashModel }
  it { is_expected.to inherit_from ExampleRedisModelParent }
  it { is_expected.to define_field :started_at, :datetime }
  it { is_expected.to define_field :finished_at, :datetime }
  it { is_expected.to define_field :count, :integer, default: 42 }
  it { is_expected.to define_field :rate, :float, default: 3.14 }

  it { is_expected.to allow_key :started_at }
  it { is_expected.to allow_key :finished_at }
  it { is_expected.to allow_key :count }
  it { is_expected.to allow_key :rate }

  describe "#data" do
    subject { redis_model.data }

    it { is_expected.to eq redis_model }
  end
end
