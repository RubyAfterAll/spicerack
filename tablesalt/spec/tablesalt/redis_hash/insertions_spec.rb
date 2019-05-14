# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Insertions, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to alias_method(:[]=, :store) }

  describe "#store" do
    subject(:assignment) { example_redis_hash.store(field, value) }

    let(:field) { SecureRandom.hex }
    let(:value) { SecureRandom.hex }
    let(:expected_hash) { {} }
    let(:expected_result) { expected_hash.merge(field => value) }

    shared_examples_for "the value is assigned" do
      it "changes the value" do
        expect { assignment }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
      end
    end

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it_behaves_like "the value is assigned"
      end

      context "without matching field" do
        it_behaves_like "the value is assigned"
      end
    end

    context "without existing data" do
      it_behaves_like "the value is assigned"
    end
  end
end
