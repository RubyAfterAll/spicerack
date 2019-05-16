# frozen_string_literal: true

RSpec.describe RedisHash::Enumerators, type: :module do
  include_context "with an example redis hash", [
    RedisHash::Accessors,
    RedisHash::Insertions,
    RedisHash::Deletions,
    described_class,
  ]

  it { is_expected.to delegate_method(:each).to(:to_h) }
  it { is_expected.to delegate_method(:each_pair).to(:to_h) }
  it { is_expected.to delegate_method(:each_key).to(:to_h) }
  it { is_expected.to delegate_method(:each_value).to(:to_h) }
  it { is_expected.to delegate_method(:reject).to(:to_h) }
  it { is_expected.to delegate_method(:select).to(:to_h) }
  it { is_expected.to delegate_method(:transform_values).to(:to_h) }

  describe "#delete_if" do
    context "without a block" do
      subject(:delete_if) { example_redis_hash.delete_if }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to be_an Enumerable }

        it "deletes when run" do
          expect { delete_if.each { |field, value| field == field0 && value == value0 } }.
            to change { redis.hgetall(redis_key) }.
            from(expected_hash).
            to(field1 => value1)
        end
      end

      context "without existing data" do
        it { is_expected.to be_an Enumerable }
      end
    end

    context "with a block" do
      shared_examples_for "items satisfying block are deleted" do
        let(:expected_result) { Hash[field1, value1] }

        context "with existing data" do
          include_context "with data in redis"

          it { is_expected.to eq expected_result }

          it "deletes matching" do
            expect { delete_if }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
          end
        end

        context "without existing data" do
          it { is_expected.to eq({}) }
        end
      end

      context "with field and value arguments" do
        subject(:delete_if) do
          example_redis_hash.delete_if { |field, value| field == field0 && value == value0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with only field argument" do
        subject(:delete_if) do
          example_redis_hash.delete_if { |field| field == field0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with no arguments" do
        subject(:delete_if) do
          example_redis_hash.delete_if { true }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:expected_result) { {} }
        end
      end
    end
  end

  describe "#keep_if" do
    context "without a block" do
      subject(:keep_if) { example_redis_hash.keep_if }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to be_an Enumerable }

        it "deletes when run" do
          expect { keep_if.each { |field, value| field == field0 && value == value0 } }.
            to change { redis.hgetall(redis_key) }.
            from(expected_hash).
            to(field0 => value0)
        end
      end

      context "without existing data" do
        it { is_expected.to be_an Enumerable }
      end
    end

    context "with a block" do
      shared_examples_for "items satisfying block are deleted" do
        let(:expected_result) { Hash[field0, value0] }

        context "with existing data" do
          include_context "with data in redis"

          it { is_expected.to eq expected_result }

          it "deletes matching" do
            expect { keep_if }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
          end
        end

        context "without existing data" do
          it { is_expected.to eq({}) }
        end
      end

      context "with field and value arguments" do
        subject(:keep_if) do
          example_redis_hash.keep_if { |field, value| field == field0 && value == value0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with only field argument" do
        subject(:keep_if) do
          example_redis_hash.keep_if { |field| field == field0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with no arguments" do
        subject(:keep_if) do
          example_redis_hash.keep_if { false }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:expected_result) { {} }
        end
      end
    end
  end

  describe "#reject!" do
    context "without a block" do
      subject(:reject!) { example_redis_hash.reject! }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to be_an Enumerable }

        it "deletes when run" do
          expect { reject!.each { |field, value| field == field0 && value == value0 } }.
            to change { redis.hgetall(redis_key) }.
            from(expected_hash).
            to(field1 => value1)
        end
      end

      context "without existing data" do
        it { is_expected.to be_an Enumerable }
      end
    end

    context "with a block" do
      shared_examples_for "items satisfying block are deleted" do
        let(:expected_result) { final_hash }
        let(:final_hash) { Hash[field1, value1] }

        context "with existing data" do
          include_context "with data in redis"

          it { is_expected.to eq expected_result }

          it "deletes matching" do
            next if expected_hash == final_hash

            expect { reject! }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(final_hash)
          end
        end

        context "without existing data" do
          it { is_expected.to eq nil }
        end
      end

      context "with field and value arguments" do
        subject(:reject!) do
          example_redis_hash.reject! { |field, value| field == field0 && value == value0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with only field argument" do
        subject(:reject!) do
          example_redis_hash.reject! { |field| field == field0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with no arguments" do
        subject(:reject!) do
          example_redis_hash.reject! { true }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:final_hash) { {} }
        end
      end

      context "when nothing is removed" do
        subject(:reject!) do
          example_redis_hash.reject! { false }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:expected_result) { nil }
          let(:final_hash) { expected_hash }
        end
      end
    end
  end

  describe "#select!" do
    context "without a block" do
      subject(:select!) { example_redis_hash.select! }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to be_an Enumerable }

        it "deletes when run" do
          expect { select!.each { |field, value| field == field0 && value == value0 } }.
            to change { redis.hgetall(redis_key) }.
            from(expected_hash).
            to(field0 => value0)
        end
      end

      context "without existing data" do
        it { is_expected.to be_an Enumerable }
      end
    end

    context "with a block" do
      shared_examples_for "items satisfying block are deleted" do
        let(:expected_result) { final_hash }
        let(:final_hash) { Hash[field0, value0] }

        context "with existing data" do
          include_context "with data in redis"

          it { is_expected.to eq expected_result }

          it "deletes unless matching" do
            next if expected_hash == final_hash

            expect { select! }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(final_hash)
          end
        end

        context "without existing data" do
          it { is_expected.to eq nil }
        end
      end

      context "with field and value arguments" do
        subject(:select!) do
          example_redis_hash.select! { |field, value| field == field0 && value == value0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with only field argument" do
        subject(:select!) do
          example_redis_hash.select! { |field| field == field0 }
        end

        it_behaves_like "items satisfying block are deleted"
      end

      context "with no arguments" do
        subject(:select!) do
          example_redis_hash.select! { false }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:final_hash) { {} }
        end
      end

      context "when nothing is removed" do
        subject(:reject!) do
          example_redis_hash.select! { true }
        end

        it_behaves_like "items satisfying block are deleted" do
          let(:expected_result) { nil }
          let(:final_hash) { expected_hash }
        end
      end
    end
  end

  describe "#transform_values!" do
    context "without a block" do
      subject(:transform_values!) { example_redis_hash.transform_values! }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to be_an Enumerable }

        it "transforms when run" do
          expect { transform_values!.each { |value| "new_#{value}" } }.
            to change { redis.hgetall(redis_key) }.
            from(expected_hash).
            to(field0 => "new_#{value0}", field1 => "new_#{value1}")
        end
      end

      context "without existing data" do
        it { is_expected.to be_an Enumerable }
      end
    end

    context "with a block" do
      shared_examples_for "items are transformed" do
        context "with existing data" do
          include_context "with data in redis"

          it { is_expected.to eq expected_result }

          it "transforms values" do
            expect { transform_values! }.to change { redis.hgetall(redis_key) }.from(expected_hash).to(expected_result)
          end
        end

        context "without existing data" do
          it { is_expected.to eq({}) }
        end
      end

      context "with argument" do
        subject(:transform_values!) do
          example_redis_hash.transform_values! { |value| "new_#{value}" }
        end

        it_behaves_like "items are transformed" do
          let(:expected_result) { Hash[field0, "new_#{value0}", field1, "new_#{value1}"] }
        end
      end

      context "with no argument" do
        subject(:transform_values!) do
          example_redis_hash.transform_values! { static_value }
        end

        let(:static_value) { SecureRandom.hex }

        it_behaves_like "items are transformed" do
          let(:expected_result) { Hash[field0, static_value, field1, static_value] }
        end
      end
    end
  end
end
