# frozen_string_literal: true

RSpec.describe Tablesalt::Isolation, type: :module do
  subject { example_dsl_object.__send__(:isolate, example_target) }

  let(:example_dsl_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  shared_examples_for "it preserves mutability" do
    it "preserves mutability" do
      expect(subject.frozen?).to eq example_target.frozen?
    end
  end

  shared_examples_for "it dupes the object" do
    it { is_expected.to eq example_target.clone }
    it { is_expected.not_to equal example_target }
    it { is_expected.to isolate example_target }

    it_behaves_like "it preserves mutability"
  end

  shared_examples_for "it doesn't dup the object" do
    it { is_expected.to equal example_target }
    it { is_expected.not_to equal example_target.clone }
    it { is_expected.to isolate example_target }

    it_behaves_like "it preserves mutability"
  end

  shared_context "when the object is frozen" do
    before { example_target.freeze }
  end

  context "when the receiver is a class" do
    let(:example_dsl_object) { example_dsl_class }

    context "when the object is an instance" do
      let(:example_target) { Faker::Hipster.sentence }

      it_behaves_like "it dupes the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it dupes the object"
      end
    end

    context "when object is a class" do
      let(:example_target) { Class.new }

      it_behaves_like "it doesn't dup the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it doesn't dup the object"
      end
    end

    context "when object is a module" do
      let(:example_target) { Module.new }

      it_behaves_like "it doesn't dup the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it doesn't dup the object"
      end
    end
  end

  context "when the receiver is an instance" do
    let(:example_dsl_object) { example_dsl_class.new }

    context "when the object is an instance" do
      let(:example_target) { Faker::Hipster.sentence }

      it_behaves_like "it dupes the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it dupes the object"
      end
    end

    context "when object is a class" do
      let(:example_target) { Class.new }

      it_behaves_like "it doesn't dup the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it doesn't dup the object"
      end
    end

    context "when object is a module" do
      let(:example_target) { Module.new }

      it_behaves_like "it doesn't dup the object"

      context "when the object is frozen" do
        include_context "when the object is frozen"

        it_behaves_like "it doesn't dup the object"
      end
    end
  end
end
