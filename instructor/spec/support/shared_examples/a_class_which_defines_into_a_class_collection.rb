# frozen_string_literal: true

RSpec.shared_examples_for "a class which defines into a class collection" do |method, collection|
  subject(:define) { example_instructor_class.__send__(method, value) }

  let(:value) { Faker::Lorem.word.to_sym }

  before do
    allow(example_instructor_class).to receive(:define_default).and_call_original
    allow(example_instructor_class).to receive(:define_attribute).and_call_original
  end

  describe "defines value" do
    let(:default) { Faker::Lorem.word }

    shared_examples_for "an value is defined" do
      it "adds to _values" do
        expect { define }.to change { example_instructor_class.public_send(collection) }.from([]).to([ value ])
      end
    end

    context "when no block is given" do
      subject(:define) { example_instructor_class.__send__(method, value, default: default) }

      it_behaves_like "an value is defined"

      it "defines an static default" do
        define
        expect(example_instructor_class).to have_received(:define_default).with(value, static: default)
      end
    end

    context "when a block is given" do
      subject(:define) { example_instructor_class.__send__(method, value, default: default, &block) }

      let(:block) do
        ->(_) { :block }
      end

      shared_examples_for "values are handed off to define_default" do
        it "calls define_default" do
          define
          expect(example_instructor_class).to have_received(:define_default).with(value, static: default, &block)
        end
      end

      context "with a static default" do
        it_behaves_like "values are handed off to define_default"
      end

      context "without a static default" do
        let(:default) { nil }

        it_behaves_like "values are handed off to define_default"
      end
    end
  end

  it "defines an attribute" do
    define
    expect(example_instructor_class).to have_received(:define_attribute).with(value)
  end
end
