# frozen_string_literal: true

RSpec.describe RedisHash::Mutations, type: :module do
  include_context "with an example redis hash", [
    RedisHash::Accessors,
    RedisHash::Insertions,
    RedisHash::Deletions,
    RedisHash::Enumerators,
    described_class,
  ]

  describe "#compact!" do
    subject(:compact!) { example_redis_hash.compact! }

    context "with existing data" do
      include_context "with data in redis"

      context "with nil field" do
        let(:value0) { "" }
        let(:expected_result) { Hash[field1, value1] }

        it { is_expected.to eq expected_result }

        it "deletes key" do
          expect { compact! }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
        end
      end

      context "without nil field" do
        it { is_expected.to eq expected_hash }
      end
    end

    context "without existing data" do
      let(:field) { SecureRandom.hex }

      it { is_expected.to eq({}) }
    end
  end

  describe "#invert" do
    subject(:invert) { example_redis_hash.invert }

    context "with existing data" do
      include_context "with data in redis"

      it "inverts hash" do
        expect { invert }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_hash.invert)
      end
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end

  describe "#replace" do
    let(:field2) { SecureRandom.hex }
    let(:value2) { SecureRandom.hex }
    let(:field3) { SecureRandom.hex }
    let(:value3) { SecureRandom.hex }

    let(:other_hash) { Hash[field2, value2, field3, value3] }

    shared_examples_for "the values are replaced" do
      shared_examples_for "the values are overwritten" do
        let(:expected_result) { other_hash }

        it "changes the value" do
          expect { replace }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
        end
      end

      context "with existing data" do
        include_context "with data in redis"

        it_behaves_like "the values are overwritten"
      end

      context "without existing data" do
        let(:expected_hash) { {} }
        let(:expected_result) { Hash[field2, value2, field3, value3] }

        it_behaves_like "the values are overwritten"
      end
    end

    context "with kwargs" do
      subject(:replace) { example_redis_hash.replace(**{ field2 => value2, field3 => value3 }.symbolize_keys) }

      it_behaves_like "the values are replaced"
    end

    context "with hash" do
      subject(:replace) { example_redis_hash.replace(field2 => value2, field3 => value3) }

      it_behaves_like "the values are replaced"
    end
  end
end
