# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Defaults::Value, type: :subclass do
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
      let(:static) { double(clone: duplicate) }

      it { is_expected.to eq duplicate }
    end

    context "with a block" do
      let(:instance) { described_class.new(&block) }
      let(:block) do
        proc { computed_value }
      end

      before { allow(instance).to receive(:computed_value).and_return(computed_value) }

      context "when evaulated object is a module" do
        let(:computed_value) { Module.new }

        it { is_expected.to isolate computed_value }
      end

      context "when evaulated object is a class" do
        let(:computed_value) { Class.new }

        it { is_expected.to isolate computed_value }
      end

      context "when evaluated object is an instance" do
        let(:computed_value) { Faker::ChuckNorris.fact }

        it { is_expected.to isolate computed_value }
      end
    end
  end
end
