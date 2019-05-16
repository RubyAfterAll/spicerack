# frozen_string_literal: true

RSpec.describe RedisHash::Default, type: :module do
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

    shared_examples_for "the default is assigned" do
      it "assigns default" do
        expect { assignment }.to change { example_redis_hash.default }.from(nil).to(:default)
      end
    end

    context "with a default_proc" do
      before { example_redis_hash.default_proc = default_proc }

      let(:default_proc) { proc {} }

      it_behaves_like "the default is assigned"

      it "clears default_proc" do
        expect { assignment }.to change { example_redis_hash.default_proc }.from(default_proc).to(nil)
      end
    end

    context "without a default_proc" do
      it_behaves_like "the default is assigned"
    end
  end

  describe "#default_proc" do
    subject { example_redis_hash.default_proc }

    it { is_expected.to eq nil }
  end

  describe "#default_proc=" do
    subject(:assignment) { example_redis_hash.default_proc = value }

    shared_examples_for "the default_proc is assigned" do
      it "assigns default_proc" do
        expect { assignment }.to change { example_redis_hash.default_proc }.from(nil).to(value)
      end
    end

    context "with a proc" do
      let(:value) { proc {} }

      context "with a default" do
        before { example_redis_hash.default = :default }

        let(:default_proc) { proc {} }

        it_behaves_like "the default_proc is assigned"

        it "clears default" do
          expect { assignment }.to change { example_redis_hash.default }.from(:default).to(nil)
        end
      end

      context "without a default" do
        it_behaves_like "the default_proc is assigned"
      end
    end

    context "with a lamda" do
      context "with no arguments" do
        let(:value) { ->{} }

        it "raises" do
          expect { assignment }.to raise_error TypeError, "default_proc takes two arguments (2 for 0)"
        end
      end

      context "with too few" do
        let(:value) { ->(x){} }

        it "raises" do
          expect { assignment }.to raise_error TypeError, "default_proc takes two arguments (2 for 1)"
        end
      end

      context "with too many" do
        let(:value) { ->(x, y, z){} }

        it "raises" do
          expect { assignment }.to raise_error TypeError, "default_proc takes two arguments (2 for 3)"
        end
      end

      context "with two" do
        let(:value) { ->(x, y){} }

        it_behaves_like "the default_proc is assigned"
      end

      context "with glob" do
        let(:value) { ->(*){} }

        it_behaves_like "the default_proc is assigned"
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
