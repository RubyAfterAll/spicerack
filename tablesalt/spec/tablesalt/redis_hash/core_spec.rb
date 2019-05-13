# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Core, type: :module do
  describe "#initialize" do
    include_context "with example class having callback", :initialize

    let(:key) { SecureRandom.hex }
    let(:redis) { instance_double(Redis) }
    let(:example_class) { example_class_having_callback.include(described_class) }

    shared_examples_for "an instance" do
      let(:expected_key) { :default }
      let(:expected_redis) { :default }

      it "has an id always" do
        if expected_key == :default
          expect(instance.key).not_to be_nil
        else
          expect(instance.key).to eq expected_key
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
      subject(:instance) { example_class.new(key) }

      it_behaves_like "an instance" do
        let(:expected_key) { key }
      end
    end

    context "with only connection" do
      subject(:instance) { example_class.new(redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_redis) { redis }
      end
    end

    context "with key and connection" do
      subject(:instance) { example_class.new(key, redis: redis) }

      it_behaves_like "an instance" do
        let(:expected_key) { key }
        let(:expected_redis) { redis }
      end
    end
  end
end
