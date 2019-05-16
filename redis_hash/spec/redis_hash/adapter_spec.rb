# frozen_string_literal: true

RSpec.describe RedisHash::Adapter, type: :module do
  subject(:example_redis_hash) { example_class.new }

  let(:example_class) { Class.new(Hash).include(described_class) }

  it { is_expected.to delegate_method(:del).to(:redis) }
  it { is_expected.to delegate_method(:hdel).to(:redis) }
  it { is_expected.to delegate_method(:hexists).to(:redis) }
  it { is_expected.to delegate_method(:hget).to(:redis) }
  it { is_expected.to delegate_method(:hgetall).to(:redis) }
  it { is_expected.to delegate_method(:hkeys).to(:redis) }
  it { is_expected.to delegate_method(:hlen).to(:redis) }
  it { is_expected.to delegate_method(:hset).to(:redis) }
  it { is_expected.to delegate_method(:hvals).to(:redis) }

  it { is_expected.to delegate_method(:default_redis).to(:class) }
  it { is_expected.to delegate_method(:default_redis_key).to(:class) }
  it { is_expected.to delegate_method(:default_redis_ttl).to(:class) }

  describe ".default_redis" do
    subject { example_class.default_redis }

    it { is_expected.to be_an_instance_of Redis }
  end

  describe ".default_redis_key" do
    subject { example_class.default_redis_key }

    it { is_expected.not_to be_nil }
  end

  describe ".default_redis_ttl" do
    subject { example_class.default_redis_ttl }

    it { is_expected.to be_nil }
  end
end
