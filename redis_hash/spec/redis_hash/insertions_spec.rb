# frozen_string_literal: true

RSpec.describe RedisHash::Insertions, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:hmset).to(:redis) }
  it { is_expected.to delegate_method(:hset).to(:redis) }
  it { is_expected.to delegate_method(:merge).to(:to_h) }

  it { is_expected.to alias_method(:update, :merge!) }
  it { is_expected.to alias_method(:[]=, :store) }

  describe "#store" do
    subject(:assignment) { example_redis_hash.store(field, value) }

    let(:field) { SecureRandom.hex }
    let(:value) { SecureRandom.hex }
    let(:expected_hash) { {} }
    let(:expected_result) { expected_hash.merge(field => value) }

    shared_examples_for "the value is assigned" do
      it "changes the value" do
        expect { assignment }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
      end
    end

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it_behaves_like "the value is assigned"
      end

      context "without matching field" do
        it_behaves_like "the value is assigned"
      end
    end

    context "without existing data" do
      it_behaves_like "the value is assigned"
    end
  end

  describe "#merge!" do
    let(:field2) { SecureRandom.hex }
    let(:value2) { SecureRandom.hex }
    let(:field3) { SecureRandom.hex }
    let(:value3) { SecureRandom.hex }

    shared_examples_for "the values are merged" do
      shared_examples_for "the values are assigned" do
        let(:expected_result) { expected_hash.merge(field2 => value2, field3 => value3) }

        it { is_expected.to eq example_redis_hash }

        it "changes the value" do
          expect { merge! }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
        end
      end

      context "with existing data" do
        include_context "with data in redis"

        it_behaves_like "the values are assigned"
      end

      context "without existing data" do
        let(:expected_hash) { {} }
        let(:expected_result) { Hash[field2, value2, field3, value3] }

        it_behaves_like "the values are assigned"
      end
    end

    context "with kwargs" do
      subject(:merge!) { example_redis_hash.merge!(**{ field2 => value2, field3 => value3 }.symbolize_keys) }

      it_behaves_like "the values are merged"
    end

    context "with hash" do
      subject(:merge!) { example_redis_hash.merge!(field2 => value2, field3 => value3) }

      it_behaves_like "the values are merged"
    end
  end
end
