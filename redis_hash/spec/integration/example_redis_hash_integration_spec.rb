# frozen_string_literal: true

require_relative "../support/test_classes/example_redis_hash"

RSpec.describe ExampleRedisHash, type: :integration do
  subject(:redis_hash) { redis_hash_class.new }

  let(:redis_hash_class) { described_class.dup }
  let(:redis) { redis_hash.redis }
  let(:redis_key) { redis_hash.redis_key }
  let(:redis_ttl) { redis_hash.redis_ttl }

  it "has a redis key and connection but no ttl" do
    expect(redis).to be_an_instance_of Redis
    expect(redis_key).not_to be_nil
    expect(redis_ttl).to be_nil
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
    expect { redis_hash.increment(:counter) }.to change { redis.hget(redis_key, :counter) }.from(nil).to("1")
    expect { redis_hash.increment(:counter) }.to change { redis.hget(redis_key, :counter) }.from("1").to("2")
    expect { redis_hash.increment(:counter, by: 2) }.to change { redis.hget(redis_key, :counter) }.from("2").to("4")
    expect { redis_hash.decrement(:counter) }.to change { redis.hget(redis_key, :counter) }.from("4").to("3")
    expect { redis_hash.decrement(:counter) }.to change { redis.hget(redis_key, :counter) }.from("3").to("2")
    expect { redis_hash.decrement(:counter, by: 2) }.to change { redis.hget(redis_key, :counter) }.from("2").to("0")
  end

  it "supports setnx with raise" do
    expect { redis_hash.setnx!(:field, :value) }.to change { redis.hget(redis_key, :field) }.from(nil).to("value")
    expect { redis_hash.setnx!(:field, :value) }.to raise_error RedisHash::AlreadyDefinedError, "field already defined"
  end

  it "supports safe setnx" do
    expect { redis_hash.setnx(:field, :value) }.to change { redis.hget(redis_key, :field) }.from(nil).to("value")
    expect(redis_hash.setnx(:field, :value)).to eq false
  end

  it "supports insertion callbacks" do
    insertion_hook_run = false
    redis_hash_class.set_callback(:insertion, :after) { insertion_hook_run = true }

    expect { redis_hash[:foo] = :foo }.to change { insertion_hook_run }.from(false).to(true)
  end

  it "supports deletion callbacks" do
    deletion_hook_run = false
    redis_hash_class.set_callback(:deletion, :after) { deletion_hook_run = true }

    redis_hash[:foo] = :foo
    expect { redis_hash.delete(:foo) }.to change { deletion_hook_run }.from(false).to(true)

    expect(deletion_hook_run).to eq true
  end

  context "with a given TTL" do
    subject(:redis_hash) { redis_hash_class.new(redis_ttl: redis_ttl) }

    let(:redis_ttl) { rand(10..100) }

    it "sets an expiration automatically only when the first key is inserted" do
      expect(redis_hash.redis_ttl).to eq redis_ttl
      expect(redis_hash).to be_empty

      expect { redis_hash[:foo] = :foo }.to change { redis_hash.ttl }.from(-2).to(redis_ttl)
      expect { redis_hash[:bar] = :bar }.not_to(change { redis_hash.ttl })
    end
  end

  it "can set expiration directly after the fact" do
    redis_hash[:foo] = :foo

    expect(redis_hash.ttl).to eq(-1)

    expiration = rand(10..100)
    expect { redis_hash.expire(expiration) }.to change { redis_hash.ttl }.from(-1).to(expiration)
  end
end
