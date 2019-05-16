# frozen_string_literal: true

RSpec.describe RedisHash::Deletions, type: :module do
  include_context "with an example redis hash", [
    RedisHash::Default,
    RedisHash::Accessors,
    RedisHash::Insertions,
    RedisHash::Predicates,
    described_class,
  ]

  it { is_expected.to delegate_method(:del).to(:redis) }
  it { is_expected.to delegate_method(:hdel).to(:redis) }

  describe "#clear" do
    subject(:clear) { example_redis_hash.clear }

    context "with existing data" do
      include_context "with data in redis"

      it "clears hash" do
        expect { clear }.to change { redis.hgetall(redis_key) }.from(expected_hash).to({})
      end
    end

    context "without existing data" do
      it { is_expected.to eq({}) }
    end
  end

  describe "#delete" do
    subject(:delete) { example_redis_hash.delete(field) }

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it { is_expected.to eq value0 }

        it "deletes key" do
          expect { delete }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(field1 => value1)
        end
      end

      context "without matching field" do
        let(:field) { SecureRandom.hex }

        it_behaves_like "a class with callback" do
          include_context "with callbacks", :deletion

          subject(:callback_runner) { delete }

          let(:example) { example_redis_hash }
          let(:example_class) { example.class }
        end

        shared_examples_for "the hash is unchanged" do
          it "has expected hash" do
            expect(redis.hgetall(redis_key)).to eq expected_hash
          end
        end

        context "with block" do
          subject(:delete) do
            example_redis_hash.delete(field) { |el| "#{el}_return_value" }
          end

          it { is_expected.to eq "#{field}_return_value" }

          it_behaves_like "the hash is unchanged"
        end

        context "without block" do
          it { is_expected.to be_nil }

          it_behaves_like "the hash is unchanged"
        end
      end
    end

    context "without existing data" do
      let(:field) { SecureRandom.hex }

      it_behaves_like "a class with callback" do
        include_context "with callbacks", :deletion

        subject(:callback_runner) { delete }

        let(:example) { example_redis_hash }
        let(:example_class) { example.class }
      end

      it { is_expected.to be_nil }
    end
  end

  describe "#shift" do
    subject(:shift) { example_redis_hash.shift }

    context "with existing data" do
      include_context "with data in redis"

      let(:field) { field0 }

      it_behaves_like "a class with callback" do
        include_context "with callbacks", :deletion

        subject(:callback_runner) { shift }

        let(:example) { example_redis_hash }
        let(:example_class) { example.class }
      end

      it { is_expected.to eq [ field0, value0 ] }

      it "deletes key" do
        expect { shift }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(field1 => value1)
      end
    end

    context "without existing data" do
      context "with default" do
        before { example_redis_hash.default = :default }

        it { is_expected.to eq :default }
      end

      context "without default_proc" do
        before do
          example_redis_hash.default_proc = proc { |hash, field| hash[field] = "default_#{field}" }
        end

        let(:expected_value) { "default_" }

        it { is_expected.to eq expected_value }

        it "inserts into hash" do
          expect { shift }.to change { redis.hgetall(redis_key) }.from({}).to("" => expected_value)
        end
      end

      context "without default" do
        it { is_expected.to be_nil }
      end
    end
  end
end
