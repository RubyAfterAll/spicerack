# frozen_string_literal: true

RSpec.shared_context "with data in redis" do
  let(:field) { SecureRandom.hex }
  let(:value) { SecureRandom.hex }

  before { redis.hset(key, field, value) }
end
