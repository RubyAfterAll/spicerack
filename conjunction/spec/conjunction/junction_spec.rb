# frozen_string_literal: true

RSpec.describe Conjunction::Junction, type: :junction do
  include_context "with an example junction"

  it { is_expected.to include_module Conjunction::Conjunctive }

  describe ".conjunction_prefix" do
    subject { example_junction_class.conjunction_prefix }

    let(:junction_prefix) { nil }

    it { is_expected.to be_nil }
  end

  describe ".conjunction_suffix" do
    subject { example_junction_class.conjunction_suffix }

    let(:junction_suffix) { nil }

    it { is_expected.to be_nil }
  end

  describe ".prototype_name" do
    subject { example_junction_class.prototype_name }

    context "without configuration" do
      let(:junction_prefix) { nil }
      let(:junction_suffix) { nil }

      it { is_expected.to be_nil }
    end

    context "with only prefix" do
      let(:junction_suffix) { nil }

      it { is_expected.to eq prototype_name }
    end

    context "with only suffix" do
      let(:junction_prefix) { nil }

      it { is_expected.to eq prototype_name }
    end
  end

  describe ".prototype" do
    subject { example_junction_class.prototype }

    let(:prototype) { Class.new }
    let(:prototype_name) do
      Array.new(2) { Faker::Internet.domain_word }.map(&:capitalize).join
    end

    context "when defined" do
      before { allow(example_junction_class).to receive(:prototype_name).and_return(prototype_name) }

      context "without class" do
        it { is_expected.to be_nil }
      end

      context "with class" do
        before { stub_const(prototype_name, prototype) }

        it { is_expected.to eq prototype }
      end
    end

    context "when undefined" do
      before { allow(example_junction_class).to receive(:prototype_name).and_return(nil) }

      it { is_expected.to be_nil }
    end
  end

  describe ".inherited" do
    subject(:inherited_junction_class) { Class.new(example_junction_class) }

    let(:prefix) { SecureRandom.hex }
    let(:suffix) { SecureRandom.hex }

    before do
      example_junction_class.__send__(:prefixed_with, prefix)
      example_junction_class.__send__(:suffixed_with, suffix)
    end

    it "is inherited" do
      expect(example_junction_class.conjunction_prefix).to eq prefix
      expect(example_junction_class.conjunction_suffix).to eq suffix

      expect(inherited_junction_class.conjunction_prefix).to eq prefix
      expect(inherited_junction_class.conjunction_suffix).to eq suffix
    end
  end

  describe ".prefixed_with" do
    subject(:prefixed_with) { example_junction_class.__send__(:prefixed_with, prefix) }

    context "when string" do
      let(:example_junction_class) do
        Class.new.tap { |klass| klass.include described_class }
      end

      let(:prefix) do
        Array.new(2) { Faker::Internet.domain_word }.map(&:capitalize).join
      end

      it "changes conjunction_prefix" do
        expect { prefixed_with }.to change { example_junction_class.conjunction_prefix }.from(nil).to(prefix)
      end
    end

    context "when nil" do
      let(:prefix) { nil }

      it "changes conjunction_prefix" do
        expect { prefixed_with }.to change { example_junction_class.conjunction_prefix }.from(junction_prefix).to(nil)
      end
    end

    context "when other" do
      let(:prefix) { double }

      it "raises" do
        expect { prefixed_with }.to raise_error TypeError, "prefix must be a string"
      end
    end
  end

  describe ".suffixed_with" do
    subject(:suffixed_with) { example_junction_class.__send__(:suffixed_with, suffix) }

    context "when string" do
      let(:example_junction_class) do
        Class.new.tap { |klass| klass.include described_class }
      end

      let(:suffix) do
        Array.new(2) { Faker::Internet.domain_word }.map(&:capitalize).join
      end

      it "changes conjunction_prefix" do
        expect { suffixed_with }.to change { example_junction_class.conjunction_suffix }.from(nil).to(suffix)
      end
    end

    context "when nil" do
      let(:suffix) { nil }

      it "changes conjunction_prefix" do
        expect { suffixed_with }.to change { example_junction_class.conjunction_suffix }.from(junction_suffix).to(nil)
      end
    end

    context "when other" do
      let(:suffix) { double }

      it "raises" do
        expect { suffixed_with }.to raise_error TypeError, "suffix must be a string"
      end
    end
  end
end
