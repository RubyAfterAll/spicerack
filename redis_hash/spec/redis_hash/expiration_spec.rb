# frozen_string_literal: true

RSpec.describe RedisHash::Expiration, type: :module do
  include_context "with an example redis hash", [
    RedisHash::Accessors,
    RedisHash::Insertions,
    RedisHash::Predicates,
    described_class,
  ]

  describe "#expire" do
    subject(:expire) { example_redis_hash.expire(seconds) }

    let(:seconds) { rand(10..100) }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq true }

      it "sets expiration" do
        expect { expire }.to change { redis.ttl(redis_key) }.from(-1).to(seconds)
      end
    end

    context "without existing data" do
      it { is_expected.to eq false }

      it "doesn't set expiration" do
        expect { expire }.not_to change { redis.ttl(redis_key) }
      end
    end
  end

  describe "#ttl" do
    subject { example_redis_hash.ttl }

    let(:seconds) { rand(10..100) }

    context "with existing data" do
      include_context "with data in redis"

      context "without expiration" do
        it { is_expected.to eq(-1) }
      end

      context "with expiration" do
        before { redis.expire(redis_key, seconds) }

        it { is_expected.to eq seconds }
      end
    end

    context "without existing data" do
      it { is_expected.to eq(-2) }
    end
  end

  describe "#persist" do
    subject(:persist) { example_redis_hash.persist }

    let(:seconds) { rand(10..100) }

    context "with existing data" do
      include_context "with data in redis"

      context "without expiration" do
        it { is_expected.to eq false }
      end

      context "with expiration" do
        before { redis.expire(redis_key, seconds) }

        it "unsets expiration" do
          expect { persist }.to change { example_redis_hash.ttl }.from(seconds).to(-1)
        end

        it { is_expected.to eq true }
      end
    end

    context "without existing data" do
      it { is_expected.to eq false }

      context "with redis_ttl" do
        let(:redis_ttl) { seconds }

        it "prevents ttl if called before first insertion" do
          persist
          expect { example_redis_hash[:key] = :value }.to change { example_redis_hash.ttl }.from(-2).to(-1)
        end
      end
    end
  end

  context ":insertion callbacks" do
    subject(:insertion) { example_redis_hash[:foo] = :foo }

    context "with existing data" do
      include_context "with data in redis"

      it "does nothing" do
        expect { insertion }.not_to change { example_redis_hash.empty_before_insertion? }.from(false)
      end
    end

    context "without existing data" do
      shared_examples_for "empty flag is set" do
        it "flag is set" do
          expect { insertion }.to change { example_redis_hash.empty_before_insertion? }.from(false).to(true)
        end
      end

      context "without a redis_ttl" do
        it_behaves_like "empty flag is set"
      end

      context "with a redis_ttl" do
        let(:redis_ttl) { rand(10..100) }

        it_behaves_like "empty flag is set"

        it "expiration is set" do
          expect { insertion }.to change { example_redis_hash.ttl }.from(-2).to(redis_ttl)
        end
      end
    end
  end
end
