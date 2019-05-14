# frozen_string_literal: true

RSpec.shared_context "with an example redis hash" do |extra_redis_hash_modules = nil|
  subject(:example_redis_hash) { example_redis_hash_class.new(redis_key, redis: redis) }

  let(:root_redis_hash_modules) do
    [ Technologic, Tablesalt::RedisHash::Callbacks, Tablesalt::RedisHash::Core, Tablesalt::RedisHash::Identity ]
  end
  let(:redis_hash_modules) { root_redis_hash_modules + Array.wrap(extra_redis_hash_modules) }

  let(:root_redis_hash_class) { Class.new }
  let(:example_redis_hash_class) do
    root_redis_hash_class.tap do |redis_hash_class|
      redis_hash_modules.each { |redis_hash_module| redis_hash_class.include redis_hash_module }
    end
  end

  let(:redis_key) { SecureRandom.hex }
  let(:redis) { Redis.new }
end
