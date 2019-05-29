# frozen_string_literal: true

RSpec.describe Instructor::Core, type: :module do
  include_context "with an example instructor"

  describe "#initialize" do
    let(:input) { Hash[*Faker::Lorem.words(4)].symbolize_keys }

    context "when no writers are defined for the arguments" do
      it "raises" do
        expect { example_instructor }.to raise_error NoMethodError
      end
    end

    context "when writers are defined for the arguments" do
      before do
        input.each_key { |argument| example_instructor_class.attr_accessor argument }
      end

      it "assigns arguments to the attribute readers" do
        input.each { |argument, value| expect(example_instructor.public_send(argument)).to eq value }
      end

      it "stores the input" do
        expect(example_instructor.input).to eq input
      end

      it_behaves_like "a class with callback" do
        include_context "with class callbacks", :initialize

        subject(:callback_runner) { example_instructor }

        let(:example) { example_instructor_class }
        let(:example_class) { example_instructor_class }
      end
    end
  end
end
