# frozen_string_literal: true

require_relative "../../support/test_classes/example_redis_hash"

RSpec.describe ExampleRedisHash, type: :integration do
  subject { described_class }

  it { is_expected.to inherit_from RedisHash::Base }
end
