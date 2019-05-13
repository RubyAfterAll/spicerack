# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::CachedHash, type: :module do
  include_context "with an example redis hash", described_class

  describe "#_cached_hash" do
    subject { example_redis_hash.__send__(:_cached_hash) }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq(field => value) }
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end

  describe "#reload" do
    subject(:reload) { example_redis_hash.reload }

    shared_examples_for "a cached hash is (re)loaded" do
      let(:new_value) { SecureRandom.hex }
      let(:updated_data) { Hash[field, new_value] }

      it { is_expected.to eq example_redis_hash }

      it "is surveiled" do
        allow(example_redis_hash).to receive(:surveil).and_call_original
        reload
        expect(example_redis_hash).to have_received(:surveil).with(:reload)
      end

      it "reloads data" do
        expect(example_redis_hash.__send__(:_cached_hash)).to eq existing_data

        redis.hset(key, field, new_value)

        expect { reload }.to change { example_redis_hash.__send__(:_cached_hash) }.to(updated_data)
      end
    end

    context "with existing data" do
      include_context "with data in redis"

      let(:existing_data) { Hash[field, value] }

      it_behaves_like "a cached hash is (re)loaded"
    end

    context "without existing data" do
      let(:field) { SecureRandom.hex }

      let(:existing_data) { {} }

      it_behaves_like "a cached hash is (re)loaded"
    end
  end
end
