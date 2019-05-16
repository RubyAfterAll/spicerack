# frozen_string_literal: true

RSpec.shared_context "with data in redis" do
  let(:field0) { SecureRandom.hex }
  let(:value0) { SecureRandom.hex }
  let(:field1) { SecureRandom.hex }
  let(:value1) { SecureRandom.hex }
  let(:expected_hash) { Hash[field0, value0, field1, value1] }

  before do
    redis.hset(redis_key, field0, value0)
    redis.hset(redis_key, field1, value1)
  end
end
