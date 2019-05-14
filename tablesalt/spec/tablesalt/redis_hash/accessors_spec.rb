# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Accessors, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:hgetall).to(:redis) }

  describe "#to_h" do
    subject { example_redis_hash.to_h }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq(field => value) }
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end
end
