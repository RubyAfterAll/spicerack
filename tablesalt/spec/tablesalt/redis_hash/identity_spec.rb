# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Identity, type: :module do
  include_context "with an example redis hash"

  describe "#hash" do
    subject { example_redis_hash.hash }

    let(:expected_hash) do
      { redis_id: redis.id, redis_key: redis_key }.hash
    end

    it { is_expected.to eq expected_hash }
  end

  describe "#to_hash" do
    subject { example_redis_hash.to_hash }

    it { is_expected.to eq example_redis_hash }
  end

  describe "#to_h" do
    subject { example_redis_hash.to_h }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq expected_hash }
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end
end
