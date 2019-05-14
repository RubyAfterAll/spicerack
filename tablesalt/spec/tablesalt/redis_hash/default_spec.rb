# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Default, type: :module do
  subject(:example_redis_hash) { example_class.new }

  let(:example_class) { Class.new(Hash).include(described_class) }

  describe "#default" do
    context "when not set" do
      context "without field" do
        subject { example_redis_hash.default }

        it { is_expected.to be_nil }
      end

      context "with field" do
        subject { example_redis_hash.default(:field) }

        it { is_expected.to be_nil }
      end
    end

    context "with static default" do
      before { example_redis_hash.default = :default }

      context "without field" do
        subject { example_redis_hash.default }

        it { is_expected.to eq :default }
      end

      context "with field" do
        subject { example_redis_hash.default(:field) }

        it { is_expected.to eq :default }
      end
    end

    context "with default_proc" do
      before { example_redis_hash.default_proc = default_proc }

      let(:default_proc) do
        proc { |hash, field| hash[field] = "default_#{field}" }
      end

      context "without field" do
        subject(:default) { example_redis_hash.default }

        it { is_expected.to be_nil }

        it "changes nothing" do
          default
          expect(example_redis_hash.to_h).to be_empty
        end
      end

      context "with field" do
        subject(:default) { example_redis_hash.default(:field) }

        it { is_expected.to eq "default_field" }

        it "changes hash" do
          expect { default }.to change { example_redis_hash.to_h }.from({}).to(field: "default_field")
        end
      end
    end
  end

  describe "#default=" do
    subject(:assignment) { example_redis_hash.default = :default }

    it "assigns default" do
      expect { assignment }.to change { example_redis_hash.default }.from(nil).to(:default)
    end
  end

  describe "#default_proc" do
    subject { example_redis_hash.default_proc }

    it { is_expected.to eq nil }
  end

  describe "#default_proc=" do
    subject(:assignment) { example_redis_hash.default_proc = value }

    context "with a proc" do
      let(:value) { proc {} }

      it "assigns default_proc" do
        expect { assignment }.to change { example_redis_hash.default_proc }.from(nil).to(value)
      end
    end

    context "with something else" do
      let(:value) { SecureRandom.hex }

      it "raises" do
        expect { assignment }.to raise_error TypeError, "wrong default_proc type String (expected Proc)"
      end
    end
  end
end
