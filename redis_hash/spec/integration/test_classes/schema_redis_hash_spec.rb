# frozen_string_literal: true

require_relative "../../support/test_classes/schema_redis_hash"

RSpec.describe SchemaRedisHash, type: :integration do
  subject { described_class }

  it { is_expected.to inherit_from RedisHash::Base }
  it { is_expected.to allow_key :key0 }
  it { is_expected.to allow_key :key1 }
  it { is_expected.not_to allow_key :key2 }
end
