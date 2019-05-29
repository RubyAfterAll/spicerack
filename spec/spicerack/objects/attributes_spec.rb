# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Attributes, type: :module do
  include_context "with an example input object"

  describe ".define_attribute" do
    subject(:define_attribute) { example_input_object_class.__send__(:define_attribute, attribute) }

    let(:attribute) { Faker::Lorem.word.to_sym }

    it "adds to _attributes" do
      expect { define_attribute }.to change { example_input_object_class._attributes }.from([]).to([ attribute ])
    end

    describe "accessors" do
      subject { example_input_object_class }

      before { define_attribute }

      it { is_expected.to be_public_method_defined attribute }
      it { is_expected.to be_public_method_defined "#{attribute}=" }
    end
  end

  describe ".attribute" do
    subject { example_input_object_class }

    it { is_expected.to alias_method :attribute, :define_attribute }
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_attribute, :_attributes do
      let(:root_class) { example_input_object_class }
    end
  end

  describe "#stringable_attributes" do
    subject { example_input_object.__send__(:stringable_attributes) }

    let(:attributes) { Faker::Lorem.words(rand(1..3)).map(&:to_sym) }

    before { allow(example_input_object_class).to receive(:_attributes).and_return(attributes) }

    it { is_expected.to eq attributes }
  end
end
