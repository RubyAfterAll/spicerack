# frozen_string_literal: true

RSpec.describe Instructor::String, type: :module do
  include_context "with an example instructor", [
    ActiveModel::Model,
    ActiveModel::Validations::Callbacks,
    Instructor::Defaults,
    Instructor::Arguments,
    described_class,
  ]

  shared_examples_for "a stringable method" do |method|
    subject { example_instructor }

    before do
      allow(example_instructor).to receive(:string_for).and_call_original
      example_instructor.public_send(method)
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
    subject { example_instructor.__send__(:string_for, method) }

    let(:method) { Faker::Lorem.word.to_sym }
    let(:class_name) { Faker::Internet.domain_word.capitalize }
    let(:test_string) { Faker::Lorem.sentence }

    before do
      stub_const(class_name, example_instructor_class)
      allow(example_instructor).to receive(:attribute_string).with(method).and_return(test_string)
    end

    it { is_expected.to eq "#<#{class_name} #{test_string}>" }
  end

  describe "#attribute_string" do
    subject { example_instructor.__send__(:attribute_string, format) }

    let(:format) { Faker::Lorem.unique.word }
    let(:test_value1) { double }
    let(:test_value2) { double }
    let(:fake_value1) { Faker::Lorem.unique.word }
    let(:fake_value2) { Faker::Lorem.unique.word }
    let(:stringable_attribute_values) do
      { test_key1: test_value1, test_key2: test_value2 }
    end

    before do
      allow(example_instructor).to receive(:stringable_attribute_values).and_return(stringable_attribute_values)
      allow(test_value1).to receive(format).and_return(fake_value1)
      allow(test_value2).to receive(format).and_return(fake_value2)
    end

    it { is_expected.to eq "test_key1=#{fake_value1} test_key2=#{fake_value2}" }
  end

  describe "#stringable_attribute_values" do
    subject { example_instructor.__send__(:stringable_attribute_values) }

    let(:example_instructor) { example_class.new(**input) }
    let(:input) do
      { test_attribute1: :test_value1, test_attribute2: :test_value2 }
    end
    let(:example_class) do
      Class.new(example_instructor_class) do
        argument :test_attribute1
        argument :test_attribute2
      end
    end

    let(:base_expected_value) do
      { test_attribute1: :test_value1 }
    end

    context "with errors" do
      let(:expected_value) { base_expected_value.merge(test_attribute2: nil) }

      before { allow(example_instructor).to receive(:test_attribute2).and_raise StandardError }

      it { is_expected.to eq expected_value }
    end

    context "without errors" do
      let(:expected_value) { base_expected_value.merge(test_attribute2: :test_value2) }

      it { is_expected.to eq expected_value }
    end
  end

  describe "#stringable_attributes" do
    subject { example_instructor.__send__(:stringable_attributes) }

    let(:attributes) { Faker::Lorem.words(rand(1..3)).map(&:to_sym) }

    before { allow(example_instructor_class).to receive(:_attributes).and_return(attributes) }

    it { is_expected.to eq attributes }
  end
end
