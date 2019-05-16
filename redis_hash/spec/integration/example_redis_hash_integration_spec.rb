# frozen_string_literal: true

require_relative "../support/test_classes/example_redis_hash"

RSpec.describe ExampleRedisHash, type: :integration do
  subject(:redis_hash) { described_class.new }

  let(:redis) { redis_hash.redis }
  let(:redis_key) { redis_hash.redis_key }

  it "has a redis key and connection" do
    expect(redis).to be_an_instance_of Redis
    expect(redis_key).not_to be_nil
  end

  it "stores data in redis" do
    expect { redis_hash[:my_key] = :my_value }.to change { redis.hget(redis_key, :my_key) }.from(nil).to("my_value")
  end

  it "retrieves data from redis as it changes" do
    redis.hset(redis_key, :my_key, :my_first_value)

    expect(redis_hash[:my_key]).to eq "my_first_value"

    redis.hset(redis_key, :my_key, :my_second_value)

    expect(redis_hash[:my_key]).to eq "my_second_value"

    redis.flushall

    expect(redis_hash[:my_key]).to be_nil
  end

  it "updates by merge!" do
    redis.hset(redis_key, :my_key, :my_first_value)

    expect { redis_hash.merge!(my_key: :new_val, new_key: :new_val) }.
      to change { redis.hgetall(redis_key) }.
      from("my_key" => "my_first_value").
      to("my_key" => "new_val", "new_key" => "new_val")
  end

  it "updates by reject!" do
    redis.hset(redis_key, :my_key, :my_first_value)
    redis.hset(redis_key, :my_other_key, :my_other_value)

    expect { redis_hash.reject! { |key, value| key == "my_other_key" || value == "my_first_value" } }.
      to change { redis.hgetall(redis_key) }.
      from("my_key" => "my_first_value", "my_other_key" => "my_other_value").
      to({})
  end

  it "supports conversion from other hashes" do
    converted_redis_hash = described_class.try_convert(a: :b)

    expect(converted_redis_hash).to be_a described_class
    expect(converted_redis_hash[:a]).to eq "b"
  end

  it "supports population from balanced argument input" do
    converted_redis_hash = described_class[:a, :b, :c, :d]

    expect(converted_redis_hash).to be_a described_class
    expect(converted_redis_hash[:a]).to eq "b"
    expect(converted_redis_hash[:c]).to eq "d"
  end

  it "supports population from associative arrays" do
    converted_redis_hash = described_class[[ %i[a b], %i[c d] ]]

    expect(converted_redis_hash).to be_a described_class
    expect(converted_redis_hash[:a]).to eq "b"
    expect(converted_redis_hash[:c]).to eq "d"
  end

  it "supports population from hashable objects" do
    converted_redis_hash = described_class[a: :b, c: :d]

    expect(converted_redis_hash).to be_a described_class
    expect(converted_redis_hash[:a]).to eq "b"
    expect(converted_redis_hash[:c]).to eq "d"
  end

  context "with default" do
    context "when proc" do
      subject(:redis_hash) do
        described_class.new { |hash, field| hash[field] = "default_#{field}" }
      end

      it "uses default" do
        expect(redis_hash[:foo]).to eq "default_foo"
        expect(redis_hash[1]).to eq "default_1"
        expect(redis.hgetall(redis_key)).to eq("foo" => "default_foo", "1" => "default_1")
      end
    end

    context "when static" do
      subject(:redis_hash) { described_class.new(:static_default) }

      it "uses default" do
        expect(redis_hash[:foo]).to eq :static_default
        expect(redis_hash[1]).to eq :static_default
        expect(redis.hgetall(redis_key)).to eq({})
      end
    end
  end

  it "supports incrementing and decrementing" do
    expect { redis_hash.increment(:counter) }.to change { redis.hget(redis_key, "counter") }.from(nil).to("1")
    expect { redis_hash.increment(:counter) }.to change { redis.hget(redis_key, "counter") }.from("1").to("2")
    expect { redis_hash.increment(:counter, by: 2) }.to change { redis.hget(redis_key, "counter") }.from("2").to("4")
    expect { redis_hash.decrement(:counter) }.to change { redis.hget(redis_key, "counter") }.from("4").to("3")
    expect { redis_hash.decrement(:counter) }.to change { redis.hget(redis_key, "counter") }.from("3").to("2")
    expect { redis_hash.decrement(:counter, by: 2) }.to change { redis.hget(redis_key, "counter") }.from("2").to("0")
  end
end
