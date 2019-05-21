# frozen_string_literal: true

RSpec.describe RedisHash::Schema, type: :module do
  include_context "with an example redis hash"

  describe ".allow_keys" do
    shared_examples_for "the keys are allowed" do
      it "adds to _allowed_keys" do
        expect { allow_keys }.to change { example_redis_hash_class._allowed_keys }.from([]).to(expected_allowed_keys)
      end
    end

    context "with key" do
      subject(:allow_keys) { example_redis_hash_class.__send__(:allow_keys, key) }

      let(:key) { Faker::Lorem.word.to_sym }
      let(:expected_allowed_keys) { [ key ] }

      it_behaves_like "the keys are allowed"
    end

    context "with array" do
      subject(:allow_keys) { example_redis_hash_class.__send__(:allow_keys, keys) }

      let(:keys) { Faker::Lorem.words(2).map(&:to_sym) }
      let(:expected_allowed_keys) { keys }

      it_behaves_like "the keys are allowed"
    end

    context "with args" do
      subject(:allow_keys) { example_redis_hash_class.__send__(:allow_keys, key0, key1) }

      let(:key0) { Faker::Lorem.word.to_sym }
      let(:key1) { Faker::Lorem.word.to_sym }
      let(:expected_allowed_keys) { [ key0, key1 ] }

      it_behaves_like "the keys are allowed"
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :allow_keys, :_allowed_keys do
      let(:root_class) { example_redis_hash_class }
    end
  end

  describe "#assert_keys_allowed" do
    subject(:assert_keys_allowed) { example_redis_hash.__send__(:assert_keys_allowed, *keys) }

    let(:keys) { Faker::Lorem.words(2).map(&:to_sym) }

    context "with no allowed keys" do
      it { is_expected.to eq true }
    end

    context "with allowed keys" do
      before { example_redis_hash_class.__send__(:allow_keys, *allowed_keys) }

      context "with multiple invalid keys" do
        let(:allowed_keys) { SecureRandom.hex }

        it "raises" do
          expect { assert_keys_allowed }.to raise_error ArgumentError, "Impermissible keys: #{keys.join(", ")}"
        end
      end

      context "with one invalid keys" do
        let(:allowed_keys) { keys.first }

        it "raises" do
          expect { assert_keys_allowed }.to raise_error ArgumentError, "Impermissible key: #{keys.last}"
        end
      end

      context "with no invalid keys" do
        let(:allowed_keys) { keys }

        it { is_expected.to eq true }
      end
    end
  end
end
