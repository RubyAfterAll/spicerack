# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHashBase do
  subject { described_class }

  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Tablesalt::RedisHash::Callbacks }
  it { is_expected.to include_module Tablesalt::RedisHash::Core }
end
