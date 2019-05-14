# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Deletions, type: :module do
  include_context "with an example redis hash", [
    Tablesalt::RedisHash::Accessors,
    Tablesalt::RedisHash::Predicates,
    described_class,
  ]

  describe "#clear" do
    subject(:clear) { example_redis_hash.clear }

    context "with existing data" do
      include_context "with data in redis"

      it "clears hash" do
        expect { clear }.to change { redis.hgetall(redis_key) }.from(expected_hash).to({})
      end
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end

  describe "#delete" do
    subject(:delete) { example_redis_hash.delete(field) }

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it { is_expected.to eq value0 }

        it "deletes key" do
          expect { delete }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(field1 => value1)
        end
      end

      context "without matching field" do
        let(:field) { SecureRandom.hex }

        shared_examples_for "the hash is unchanged" do
          it "has expected hash" do
            expect(redis.hgetall(redis_key)).to eq expected_hash
          end
        end

        context "with block" do
          subject(:delete) do
            example_redis_hash.delete(field) { |el| "#{el}_return_value" }
          end

          it { is_expected.to eq "#{field}_return_value" }

          it_behaves_like "the hash is unchanged"
        end

        context "without block" do
          it { is_expected.to be_nil }

          it_behaves_like "the hash is unchanged"
        end
      end
    end

    context "without existing data" do
      let(:field) { SecureRandom.hex }

      it { is_expected.to be_nil }
    end
  end

  describe "#shift" do
    subject(:shift) { example_redis_hash.shift }

    context "with existing data" do
      include_context "with data in redis"

      let(:field) { field0 }

      it { is_expected.to eq [ field0, value0 ] }

      it "deletes key" do
        expect { shift }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(field1 => value1)
      end
    end

    context "without existing data" do
      let(:field) { SecureRandom.hex }

      # TODO: This should return default hash value
      it { is_expected.to be_nil }
    end
  end
end
