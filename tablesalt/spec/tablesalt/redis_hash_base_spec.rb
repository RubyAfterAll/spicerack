# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHashBase do
  subject { described_class }

  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Tablesalt::RedisHash::Callbacks }
  it { is_expected.to include_module Tablesalt::RedisHash::Core }
  it { is_expected.to include_module Tablesalt::RedisHash::Identity }
  it { is_expected.to include_module Tablesalt::RedisHash::Accessors }
  it { is_expected.to include_module Tablesalt::RedisHash::Comparisons }
  it { is_expected.to include_module Tablesalt::RedisHash::Predicates }
  it { is_expected.to include_module Tablesalt::RedisHash::Deletions }
end
