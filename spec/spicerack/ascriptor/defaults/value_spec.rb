# frozen_string_literal: true

RSpec.describe Spicerack::Ascriptor::Defaults::Value, type: :subclass do
  describe "#initialize" do
    subject { instance.instance_variable_get(:@value) }

    shared_examples_for "a static value is used" do
      let(:static) { Faker::Lorem.word }

      it { is_expected.to eq static }
    end

    context "without a block" do
      let(:instance) { described_class.new(static: static) }

      it_behaves_like "a static value is used"

      context "with no static value" do
        let(:static) { nil }

        it { is_expected.to be_nil }
      end
    end

    context "with a block" do
      let(:instance) { described_class.new(static: static, &block) }
      let(:block) do
        -> { :default_value }
      end

      it_behaves_like "a static value is used"

      context "with no static value" do
        let(:static) { nil }

        it { is_expected.to eq block }
      end
    end
  end

  describe "#value" do
    subject { instance.value }

    context "without a block" do
      let(:instance) { described_class.new(static: static) }
      let(:duplicate) { double }
      let(:static) { double(dup: duplicate) }

      it { is_expected.to eq duplicate }
    end

    context "with a block" do
      let(:instance) { described_class.new(&block) }
      let(:block) do
        proc { :duplicated_object_from_block }
      end

      it { is_expected.to eq :duplicated_object_from_block }
    end
  end
end
