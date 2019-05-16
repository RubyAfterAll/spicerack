# frozen_string_literal: true

RSpec.describe RedisHash::Core, type: :module do
  include_context "with example class having callback", :initialize

  subject { example_class.new }

  let(:example_class) do
    example_class_having_callback.tap do |klass|
      klass.include RedisHash::Adapter
      klass.include RedisHash::Default
      klass.include described_class
    end
  end

  describe "#initialize" do
    let(:redis) { instance_double(Redis) }
    let(:redis_key) { SecureRandom.hex }
    let(:redis_ttl) { rand(30..60) }

    shared_examples_for "an instance" do
      let(:expected_redis) { :default }
      let(:expected_redis_key) { :default }
      let(:expected_redis_ttl) { :default }

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

      it "has a ttl only if specified" do
        if expected_redis_ttl == :default
          expect(instance.redis_ttl).to be_nil
        else
          expect(instance.redis_ttl).to eq expected_redis_ttl
        end
      end
    end

    context "with no arguments" do
      subject(:instance) { example_class.new }

      it_behaves_like "an instance"
    end

    context "with only connection" do
      subject(:instance) { example_class.new(redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis) { redis }
      end
    end

    context "with only a redis_key" do
      subject(:instance) { example_class.new(redis_key: redis_key) }

      it_behaves_like "an instance" do
        let(:expected_redis_key) { redis_key }
      end
    end

    context "with only a redis_ttl" do
      subject(:instance) { example_class.new(redis_ttl: redis_ttl) }

      it_behaves_like "an instance" do
        let(:expected_redis_ttl) { redis_ttl }
      end
    end

    context "with connection and key" do
      subject(:instance) { example_class.new(redis_key: redis_key, redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis_key) { redis_key }
        let(:expected_redis) { redis }
      end
    end

    context "with connection and ttl" do
      subject(:instance) { example_class.new(redis_ttl: redis_ttl, redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis) { redis }
        let(:expected_redis_ttl) { redis_ttl }
      end
    end

    context "with key and ttl" do
      subject(:instance) { example_class.new(redis_key: redis_key, redis_ttl: redis_ttl) }

      it_behaves_like "an instance" do
        let(:expected_redis_key) { redis_key }
        let(:expected_redis_ttl) { redis_ttl }
      end
    end

    context "with only a default" do
      subject(:instance) { example_class.new(:default) }

      it_behaves_like "an instance"

      it "has a default" do
        expect(instance.default).to eq :default
      end
    end

    context "with only a block" do
      subject(:instance) do
        example_class.new { :default }
      end

      it_behaves_like "an instance"

      it "has a default" do
        expect(instance.default_proc).to be_a Proc
      end
    end

    context "with a default and block" do
      subject(:instance) do
        example_class.new(:default) { :default }
      end

      it "raises" do
        expect { instance }.to raise_error ArgumentError, "cannot specify both block and static default"
      end
    end
  end
end
