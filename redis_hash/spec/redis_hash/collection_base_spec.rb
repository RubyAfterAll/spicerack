# frozen_string_literal: true

RSpec.describe RedisHash::Base, type: :redis_hash do
  subject { described_class }

  it { is_expected.to include_module RedisHash::Adapter }
  it { is_expected.to include_module RedisHash::Default }
  it { is_expected.to include_module RedisHash::Callbacks }
  it { is_expected.to include_module RedisHash::Core }
  it { is_expected.to include_module RedisHash::Schema }
  it { is_expected.to include_module RedisHash::Identity }
  it { is_expected.to include_module RedisHash::Accessors }
  it { is_expected.to include_module RedisHash::Comparisons }
  it { is_expected.to include_module RedisHash::Predicates }
  it { is_expected.to include_module RedisHash::Insertions }
  it { is_expected.to include_module RedisHash::Deletions }
  it { is_expected.to include_module RedisHash::Enumerators }
  it { is_expected.to include_module RedisHash::Mutations }
  it { is_expected.to include_module RedisHash::Converters }
  it { is_expected.to include_module RedisHash::Counters }
  it { is_expected.to include_module RedisHash::Expiration }
end
