# frozen_string_literal: true

RSpec.describe RedisHash::Insertions, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:hmset).to(:redis) }
  it { is_expected.to delegate_method(:hset).to(:redis) }
  it { is_expected.to delegate_method(:merge).to(:to_h) }

  it { is_expected.to alias_method(:update, :merge!) }
  it { is_expected.to alias_method(:[]=, :store) }

  shared_examples_for "schema enforced insertion" do
    shared_examples_for "the value is assigned" do
      it "changes the value" do
        expect { subject }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
      end
    end

    shared_examples_for "allowed keys are enforced" do
      context "when impermissible" do
        before { example_redis_hash_class.__send__(:allow_keys, SecureRandom.hex) }

        it "raises" do
          expect { subject }.to raise_error ArgumentError
        end
      end

      context "with allowed keys" do
        before { example_redis_hash_class.__send__(:allow_keys, expected_result.keys) }

        it_behaves_like "the value is assigned"
      end
    end
  end

  describe "#merge!" do
    let(:field2) { SecureRandom.hex }
    let(:value2) { SecureRandom.hex }
    let(:field3) { SecureRandom.hex }
    let(:value3) { SecureRandom.hex }

    shared_examples_for "the values are merged" do
      it_behaves_like "a class with callback" do
        include_context "with callbacks", :insertion

        subject(:callback_runner) { merge! }

        let(:example) { example_redis_hash }
        let(:example_class) { example.class }
      end

      context "with existing data" do
        include_context "with data in redis"

        let(:expected_result) { expected_hash.merge(field2 => value2, field3 => value3) }

        it { is_expected.to eq example_redis_hash }

        it_behaves_like "schema enforced insertion"
      end

      context "without existing data" do
        let(:expected_hash) { {} }
        let(:expected_result) { Hash[field2, value2, field3, value3] }

        it { is_expected.to eq example_redis_hash }

        it_behaves_like "schema enforced insertion"
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

  describe "#store" do
    subject(:store) { example_redis_hash.store(field, value) }

    let(:field) { SecureRandom.hex }
    let(:value) { SecureRandom.hex }
    let(:expected_hash) { {} }
    let(:expected_result) { expected_hash.merge(field => value) }

    it_behaves_like "a class with callback" do
      include_context "with callbacks", :insertion

      subject(:callback_runner) { store }

      let(:example) { example_redis_hash }
      let(:example_class) { example.class }
    end

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it_behaves_like "schema enforced insertion"
      end

      context "without matching field" do
        it_behaves_like "schema enforced insertion"
      end
    end

    context "without existing data" do
      it_behaves_like "schema enforced insertion"
    end
  end

  describe "#setnx!" do
    subject(:setnx!) { example_redis_hash.setnx!(field, value) }

    let(:field) { SecureRandom.hex }
    let(:value) { SecureRandom.hex }
    let(:expected_hash) { {} }
    let(:expected_result) { expected_hash.merge(field => value) }

    it_behaves_like "a class with callback" do
      include_context "with callbacks", :insertion

      subject(:callback_runner) { setnx! }

      let(:example) { example_redis_hash }
      let(:example_class) { example.class }
    end

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it "raises" do
          expect { setnx! }.to raise_error RedisHash::AlreadyDefinedError, "#{field} already defined"
        end
      end

      context "without matching field" do
        it { is_expected.to eq true }

        it_behaves_like "schema enforced insertion"
      end
    end

    context "without existing data" do
      it { is_expected.to eq true }

      it_behaves_like "schema enforced insertion"
    end
  end

  describe "#setnx" do
    subject(:setnx) { example_redis_hash.setnx(field, value) }

    let(:field) { SecureRandom.hex }
    let(:value) { SecureRandom.hex }
    let(:expected_hash) { {} }
    let(:expected_result) { expected_hash.merge(field => value) }

    it_behaves_like "a class with callback" do
      include_context "with callbacks", :insertion

      subject(:callback_runner) { setnx }

      let(:example) { example_redis_hash }
      let(:example_class) { example.class }
    end

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it { is_expected.to eq false }

        it "doesn't change the value" do
          expect { setnx }.not_to change { redis.hgetall(redis_key) }
        end
      end

      context "without matching field" do
        it { is_expected.to eq true }

        it_behaves_like "schema enforced insertion"
      end
    end

    context "without existing data" do
      it { is_expected.to eq true }

      it_behaves_like "schema enforced insertion"
    end
  end
end
