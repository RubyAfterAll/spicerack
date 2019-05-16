# frozen_string_literal: true

RSpec.describe RedisHash::Converters, type: :module do
  include_context "with an example redis hash", [
    RedisHash::Accessors,
    RedisHash::Predicates,
    RedisHash::Insertions,
    described_class,
  ]

  describe ".[]" do
    subject(:conversion) { example_redis_hash_class[*arguments] }

    let(:unhashable_arguments) do
      Array.new(argument_count) { Faker::Lorem.word }
    end

    let(:hashable_arguments) do
      Array.new(argument_count) { Hash[*Faker::Lorem.words(2)] }
    end

    shared_examples_for "an odd number error is raised" do
      it "raises" do
        expect { conversion }.to raise_error ArgumentError, "odd number of arguments for Hash"
      end
    end

    shared_examples_for "conversion is successful" do
      let(:expected_hash) { Hash[*arguments.map(&:to_s)] }

      shared_examples_for "a converted hash" do
        it { is_expected.to be_a example_redis_hash_class }

        it "is populated with expected data" do
          expect(conversion.to_h).to eq expected_hash
        end
      end

      context "without options block" do
        it_behaves_like "a converted hash"
      end

      context "with options block" do
        subject(:conversion) do
          example_redis_hash_class[*arguments, &->(options) { options.merge(redis_key: redis_key) }]
        end

        let(:redis_key) { Faker::Lorem.word }

        it_behaves_like "a converted hash"

        it "uses options" do
          expect(conversion.redis_key).to eq redis_key
        end
      end
    end

    context "with one argument" do
      let(:argument_count) { 1 }

      context "when unhashable" do
        let(:arguments) { unhashable_arguments }

        it_behaves_like "an odd number error is raised"
      end

      context "when hashable" do
        let(:arguments) { hashable_arguments }

        it_behaves_like "conversion is successful" do
          let(:expected_hash) { hashable_arguments.first }
        end
      end
    end

    context "when odd" do
      let(:argument_count) { 3 }

      context "when unhashable" do
        let(:arguments) { unhashable_arguments }

        it_behaves_like "an odd number error is raised"
      end

      context "when hashable" do
        let(:arguments) { hashable_arguments }

        it_behaves_like "an odd number error is raised"
      end
    end

    context "when even" do
      let(:argument_count) { 2 }

      context "when unhashable" do
        let(:arguments) { unhashable_arguments }

        it_behaves_like "conversion is successful"
      end

      context "when hashable" do
        let(:arguments) { hashable_arguments }

        it_behaves_like "conversion is successful"
      end
    end
  end

  describe ".try_convert" do
    subject(:try_convert) { example_redis_hash_class.try_convert(argument) }

    context "with nil argument" do
      let(:argument) { nil }

      it { is_expected.to be_nil }
    end

    context "with unhashable argument" do
      let(:argument) { :symbol }

      it { is_expected.to be_nil }
    end

    context "with unhashable argument having a #to_h method" do
      let(:argument) { %i[symbol] }

      it { is_expected.to be_nil }
    end

    context "with hashable argument" do
      let(:argument) { Hash[*Faker::Lorem.words(2)] }

      shared_examples_for "a successful conversion" do
        it { is_expected.to be_a example_redis_hash_class }

        it "is populated with expected data" do
          expect(try_convert.to_h).to eq argument
        end
      end

      context "without options block" do
        it_behaves_like "a successful conversion"
      end

      context "with options block" do
        subject(:try_convert) do
          example_redis_hash_class.try_convert(argument) { |options| options.merge(redis_key: redis_key) }
        end

        let(:redis_key) { Faker::Lorem.word }

        it_behaves_like "a successful conversion"

        it "uses options" do
          expect(try_convert.redis_key).to eq redis_key
        end
      end
    end
  end
end
