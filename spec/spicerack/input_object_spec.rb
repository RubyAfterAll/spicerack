# frozen_string_literal: true

RSpec.describe Spicerack::InputObject do
  include_context "with an example input object"

  it { is_expected.to inherit_from Spicerack::AttributeObject }
  it { is_expected.to include_module Spicerack::Objects::Arguments }
  it { is_expected.to include_module Spicerack::Objects::Options }

  describe "#initialize" do
    let(:input) { Hash[*Faker::Lorem.words(4)].symbolize_keys }

    context "when no writers are defined for the arguments" do
      it "raises" do
        expect { example_input_object }.to raise_error NoMethodError
      end
    end

    context "when writers are defined for the arguments" do
      before do
        input.each_key { |argument| example_input_object_class.attr_accessor argument }
      end

      it "stores the raw input" do
        expect(example_input_object.__send__(:input)).to eq input
      end

      it "assigns arguments to the attribute readers" do
        input.each { |argument, value| expect(example_input_object.public_send(argument)).to eq value }
      end

      it_behaves_like "a class with callback" do
        include_context "with class callbacks", :initialize

        subject(:callback_runner) { example_input_object }

        let(:example) { example_input_object_class }
        let(:example_class) { example_input_object_class }
      end
    end
  end
end
