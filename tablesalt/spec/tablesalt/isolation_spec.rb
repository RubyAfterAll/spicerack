# frozen_string_literal: true

RSpec.describe Tablesalt::Isolation, type: :module do
  subject { example_dsl_object.__send__(:isolate, example_target) }

  let(:duped_object) { example_target.dup }
  let(:example_dsl_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  before do
    allow(example_target).to receive(:dup).and_return(duped_object)
  end

  shared_examples_for "it dupes the object" do
    it { is_expected.to equal duped_object }
    it { is_expected.not_to equal example_target }
  end

  shared_examples_for "it doesn't dup the object" do
    it { is_expected.to equal example_target }
    it { is_expected.not_to equal duped_object }
  end

  context "when the receiver is a class" do
    let(:example_dsl_object) { example_dsl_class }

    context "when the object is an instance" do
      let(:example_target) { Object.new }

      it_behaves_like "it dupes the object"
    end

    context "when object is a class" do
      let(:example_target) { Class.new }

      it_behaves_like "it doesn't dup the object"
    end

    context "when object is a module" do
      let(:example_target) { Module.new }

      it_behaves_like "it doesn't dup the object"
    end
  end

  context "when the receiver is an instance" do
    let(:example_dsl_object) { example_dsl_class.new }

    context "when the object is an instance" do
      let(:example_target) { Object.new }

      it_behaves_like "it dupes the object"
    end

    context "when object is a class" do
      let(:example_target) { Class.new }

      it_behaves_like "it doesn't dup the object"
    end

    context "when object is a module" do
      let(:example_target) { Module.new }

      it_behaves_like "it doesn't dup the object"
    end
  end
end
