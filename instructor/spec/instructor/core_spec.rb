# frozen_string_literal: true

RSpec.describe Instructor::Core, type: :module do
  describe "#initialize" do
    include_context "with example class having callback", :initialize

    subject(:instance) { example_class.new(**arguments) }

    let(:arguments) { Hash[*Faker::Lorem.words(4)].symbolize_keys }
    let(:example_class) { example_class_having_callback.include(Instructor::Core) }

    context "when no writers are defined for the arguments" do
      it "raises" do
        expect { instance }.to raise_error NoMethodError
      end
    end

    context "when writers are defined for the arguments" do
      before do
        arguments.each_key { |argument| example_class.attr_accessor argument }
      end

      it "assigns arguments to the attribute readers" do
        arguments.each { |argument, value| expect(instance.public_send(argument)).to eq value }
      end

      it "stores the input" do
        expect(instance.input).to eq arguments
      end

      it_behaves_like "a class with callback" do
        subject(:callback_runner) { instance }

        let(:example) { example_class }
      end
    end
  end
end
