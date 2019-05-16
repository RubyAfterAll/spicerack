# frozen_string_literal: true

RSpec.describe RedisHash::Predicates, type: :module do
  include_context "with an example redis hash", [ RedisHash::Accessors, described_class ]

  it { is_expected.to delegate_method(:hexists).to(:redis) }

  it { is_expected.to alias_method(:has_key?, :include?) }
  it { is_expected.to alias_method(:key?, :include?) }
  it { is_expected.to alias_method(:member?, :include?) }
  it { is_expected.to alias_method(:has_value?, :value?) }

  describe "#any?" do
    context "without a block" do
      subject { example_redis_hash.any? }

      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to eq true }
      end

      context "without existing data" do
        it { is_expected.to eq false }
      end
    end

    context "with a block" do
      context "with existing data" do
        include_context "with data in redis"

        context "with matching values" do
          subject do
            example_redis_hash.any? { |field, value| field == field0 && value == value0 }
          end

          it { is_expected.to eq true }
        end

        context "with no matching values" do
          subject do
            example_redis_hash.any? { |field| field == value0 }
          end

          it { is_expected.to eq false }
        end
      end

      context "without existing data" do
        subject { example_redis_hash.any?(&:eql?) }

        it { is_expected.to eq false }
      end
    end
  end

  describe "#empty?" do
    subject { example_redis_hash.empty? }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq false }
    end

    context "without existing data" do
      it { is_expected.to eq true }
    end
  end

  describe "#include?" do
    subject { example_redis_hash.include?(field) }

    let(:field) { SecureRandom.hex }

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it { is_expected.to eq true }
      end

      context "without matching field" do
        it { is_expected.to eq false }
      end
    end

    context "without existing data" do
      it { is_expected.to eq false }
    end
  end

  describe "#value?" do
    subject { example_redis_hash.value?(value) }

    let(:value) { SecureRandom.hex }

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:value) { value0 }

        it { is_expected.to eq true }
      end

      context "without matching field" do
        it { is_expected.to eq false }
      end
    end

    context "without existing data" do
      it { is_expected.to eq false }
    end
  end
end
