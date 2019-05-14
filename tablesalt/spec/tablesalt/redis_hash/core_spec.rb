# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Core, type: :module do
  include_context "with example class having callback", :initialize

  subject { example_class.new }

  let(:example_class) { example_class_having_callback.include(described_class) }

  it { is_expected.to delegate_method(:del).to(:redis) }
  it { is_expected.to delegate_method(:hdel).to(:redis) }
  it { is_expected.to delegate_method(:hexists).to(:redis) }
  it { is_expected.to delegate_method(:hget).to(:redis) }
  it { is_expected.to delegate_method(:hgetall).to(:redis) }
  it { is_expected.to delegate_method(:hkeys).to(:redis) }
  it { is_expected.to delegate_method(:hlen).to(:redis) }
  it { is_expected.to delegate_method(:hset).to(:redis) }
  it { is_expected.to delegate_method(:hvals).to(:redis) }

  describe "#initialize" do
    let(:redis_key) { SecureRandom.hex }
    let(:redis) { instance_double(Redis) }

    shared_examples_for "an instance" do
      let(:expected_redis_key) { :default }
      let(:expected_redis) { :default }

      it "has an id always" do
        if expected_redis_key == :default
          expect(instance.redis_key).not_to be_nil
        else
          expect(instance.redis_key).to eq expected_redis_key
        end
      end

      it "has a redis connection always" do
        if expected_redis == :default
          expect(instance.redis).to be_an_instance_of Redis
        else
          expect(instance.redis).to eq expected_redis
        end
      end
    end

    context "with no arguments" do
      subject(:instance) { example_class.new }

      it_behaves_like "an instance"
    end

    context "with only a key" do
      subject(:instance) { example_class.new(redis_key) }

      it_behaves_like "an instance" do
        let(:expected_redis_key) { redis_key }
      end
    end

    context "with only connection" do
      subject(:instance) { example_class.new(redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis) { redis }
      end
    end

    context "with key and connection" do
      subject(:instance) { example_class.new(redis_key, redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis_key) { redis_key }
        let(:expected_redis) { redis }
      end
    end
  end
end
