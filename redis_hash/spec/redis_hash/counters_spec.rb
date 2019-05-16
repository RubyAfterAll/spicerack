# frozen_string_literal: true

RSpec.describe RedisHash::Counters, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:hincrby).to(:redis) }
  it { is_expected.to delegate_method(:hincrbyfloat).to(:redis) }

  shared_examples_for "a counter field" do |counter_type|
    subject(:counter) { example_redis_hash.public_send(counter_type, field, by: by) }

    let(:modifier) { (counter_type == :increment) ? 1 : -1 }
    let(:field) { SecureRandom.hex }
    let(:by) { 1 }

    context "when by: is negative" do
      let(:by) { -1 }

      it "raises" do
        expect { counter }.to raise_error ArgumentError, "by must be greater than or equal to 0"
      end
    end

    shared_examples_for "a modified field" do
      let(:starting_value) { rand(1..3) }
      let(:ending_value) { (starting_value || 0) + (by * modifier) }
      let(:original_value) { starting_value.nil? ? nil : starting_value.to_s }
      let(:expected_value) { ending_value.to_s }

      context "when by is not specified" do
        subject(:counter) { example_redis_hash.public_send(counter_type, field) }

        it { is_expected.to eq ending_value }
      end

      context "when by: is 0" do
        let(:by) { 0 }

        it { is_expected.to eq ending_value }

        it "does not increment value" do
          if starting_value.nil?
            expect { counter }.to change { redis.hget(redis_key, field) }.from(original_value).to(expected_value)
          else
            expect { counter }.not_to(change { redis.hget(redis_key, field) })
          end
        end
      end

      context "when by: is 1" do
        it { is_expected.to eq ending_value }

        it "increments value" do
          expect { counter }.to change { redis.hget(redis_key, field) }.from(original_value).to(expected_value)
        end
      end

      context "when by: is 3" do
        it { is_expected.to eq ending_value }

        it "increments value" do
          expect { counter }.to change { redis.hget(redis_key, field) }.from(original_value).to(expected_value)
        end
      end
    end

    context "without data" do
      it_behaves_like "a modified field" do
        let(:starting_value) { nil }
      end
    end

    context "with data" do
      before { redis.hset(redis_key, field, starting_value) }

      it_behaves_like "a modified field"
    end
  end

  describe "#increment" do
    it_behaves_like "a counter field", :increment
  end

  describe "#decrement" do
    it_behaves_like "a counter field", :decrement
  end
end
