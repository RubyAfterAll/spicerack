# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Identity, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to alias_method(:==, :eql?) }

  describe "#<" do
    subject { example_redis_hash < other }

    it_behaves_like "an expected comparison", for_superset: true
  end

  describe "#<=" do
    subject { example_redis_hash <= other }

    it_behaves_like "an expected comparison", for_superset: true, for_sameset: true
  end

  describe "#>" do
    subject { example_redis_hash > other }

    it_behaves_like "an expected comparison", for_subset: true
  end

  describe "#>=" do
    subject { example_redis_hash >= other }

    it_behaves_like "an expected comparison", for_subset: true, for_sameset: true
  end

  describe "#eql?" do
    subject(:eql?) { example_redis_hash.eql? other }

    context "when other is nil" do
      let(:other) { nil }

      it { is_expected.to be false }
    end

    context "when other is something else" do
      let(:other) { SecureRandom.hex }

      it { is_expected.to be false }
    end

    context "when other is a redis hash" do
      let(:other) { example_redis_hash_class.new(other_key, redis: other_redis) }
      let(:different_redis) { Redis.new(db: 15) }

      context "with matching key" do
        let(:other_key) { key }

        context "with matching redis" do
          let(:other_redis) { redis }

          it { is_expected.to be true }
        end

        context "with different redis" do
          let(:other_redis) { different_redis }

          it { is_expected.to be false }
        end
      end

      context "with different key" do
        let(:other_key) { SecureRandom.hex }

        context "with matching redis" do
          let(:other_redis) { redis }

          it { is_expected.to be false }
        end

        context "with different redis" do
          let(:other_redis) { different_redis }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe "#hash" do
    subject { example_redis_hash.hash }

    let(:expected_hash) do
      { redis_id: redis.id, redis_key: key }.hash
    end

    it { is_expected.to eq expected_hash }
  end

  describe "#to_hash" do
    subject { example_redis_hash.to_hash }

    it { is_expected.to eq example_redis_hash }
  end
end
