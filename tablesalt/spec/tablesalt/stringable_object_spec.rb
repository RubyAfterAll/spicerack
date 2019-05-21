# frozen_string_literal: true

RSpec.describe Tablesalt::StringableObject, type: :concern do
  subject(:example_object) { example_class.new }

  let(:example_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  shared_examples_for "a stringable method" do |method|
    subject { example_object }

    before do
      allow(example_object).to receive(:string_for).and_call_original
      example_object.public_send(method)
    end

    it { is_expected.to have_received(:string_for).with(method) }
  end

  describe "#to_s" do
    it_behaves_like "a stringable method", :to_s
  end

  describe "#inspect" do
    it_behaves_like "a stringable method", :inspect
  end

  describe "#string_for" do
    subject { example_object.__send__(:string_for, method) }

    let(:method) { Faker::Lorem.word.to_sym }
    let(:class_name) { Faker::Internet.domain_word.capitalize }
    let(:test_string) { Faker::Lorem.sentence }

    before do
      stub_const(class_name, example_class)
      allow(example_object).to receive(:stringable_attributes).and_return(stringable_attributes)
    end

    context "without stringable_attributes" do
      let(:stringable_attributes) { [] }

      it { is_expected.to eq "#<#{class_name}>" }
    end

    context "with stringable_attributes" do
      let(:stringable_attributes) { Faker::Lorem.words }

      before do
        allow(example_object).to receive(:attribute_string).with(method).and_return(test_string)
      end

      it { is_expected.to eq "#<#{class_name} #{test_string}>" }
    end
  end

  describe "#attribute_string" do
    subject { example_object.__send__(:attribute_string, format) }

    let(:format) { Faker::Lorem.unique.word }
    let(:test_value1) { double }
    let(:test_value2) { double }
    let(:fake_value1) { Faker::Lorem.unique.word }
    let(:fake_value2) { Faker::Lorem.unique.word }
    let(:stringable_attribute_values) do
      { test_key1: test_value1, test_key2: test_value2 }
    end

    before do
      allow(example_object).to receive(:stringable_attribute_values).and_return(stringable_attribute_values)
      allow(test_value1).to receive(format).and_return(fake_value1)
      allow(test_value2).to receive(format).and_return(fake_value2)
    end

    it { is_expected.to eq "test_key1=#{fake_value1} test_key2=#{fake_value2}" }
  end

  describe "#stringable_attribute_values" do
    subject { example_object.__send__(:stringable_attribute_values) }

    let(:example_object) { child_example_class.new }
    let(:child_example_class) do
      Class.new(example_class) do
        def test_attribute1
          :test_value1
        end

        def test_attribute2
          :test_value2
        end

        private

        def stringable_attributes
          %i[test_attribute1 test_attribute2]
        end
      end
    end

    let(:base_expected_value) do
      { test_attribute1: :test_value1 }
    end

    context "with errors" do
      let(:expected_value) { base_expected_value.merge(test_attribute2: nil) }

      before { allow(example_object).to receive(:test_attribute2).and_raise StandardError }

      it { is_expected.to eq expected_value }
    end

    context "without errors" do
      let(:expected_value) { base_expected_value.merge(test_attribute2: :test_value2) }

      it { is_expected.to eq expected_value }
    end
  end

  describe "#stringable_attributes" do
    subject { example_object.__send__(:stringable_attributes) }

    it { is_expected.to eq [] }
  end
end
