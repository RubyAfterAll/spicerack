# frozen_string_literal: true

RSpec.describe ProcessorRedisModel, type: :integration do
  subject(:redis_model) { described_class.new }

  it { is_expected.to inherit_from TaskRedisModel }
  it { is_expected.to define_field :count, :integer, default: 42 }
  it { is_expected.to define_field :rate, :float, default: 3.14 }

  it { is_expected.to allow_key :count }
  it { is_expected.to allow_key :rate }
end
