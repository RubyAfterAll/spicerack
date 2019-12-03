# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Arguments, type: :module do
  include_context "with an example input object"

  describe ".argument" do
    subject(:define_argument) { example_input_object_class.__send__(:argument, argument, allow_nil: allow_nil, allow_blank: allow_blank) }

    let(:argument) { Faker::Lorem.word.to_sym }
    let(:argument_value) do
      { allow_nil: allow_nil, allow_blank: allow_blank }
    end
    let(:allow_nil) { true }
    let(:allow_blank) { true }

    before { allow(example_input_object_class).to receive(:define_attribute).and_call_original }

    shared_examples_for "an argument is defined" do
      it "adds to _arguments" do
        expect { define_argument }.to change { example_input_object_class._arguments }.to(argument => argument_value)
      end

      it "defines an attribute" do
        define_argument
        expect(example_input_object_class).to have_received(:define_attribute).with(argument)
      end
    end

    context "with default options" do
      subject(:define_argument) { example_input_object_class.__send__(:argument, argument) }

      it_behaves_like "an argument is defined"
    end

    context "with allow_blank" do
      context "with allow_blank: true" do
        context "with allow_nil: true" do
          it_behaves_like "an argument is defined"
        end

        context "with allow_nil: false" do
          let(:allow_nil) { false }

          it_behaves_like "an argument is defined"
        end
      end

      context "with allow_blank: false" do
        let(:allow_blank) { false }

        context "with allow_nil: true" do
          it_behaves_like "an argument is defined"
        end

        context "with allow_nil: false" do
          let(:allow_nil) { false }

          it_behaves_like "an argument is defined"
        end
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :argument do
      let(:root_class) { example_input_object_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |argument, hash|
          hash[argument] = { allow_nil: true, allow_blank: true }
        end
      end
    end
  end

  describe ".after_initialize" do
    before do
      example_input_object_class.__send__(:argument, :argument1)
      example_input_object_class.__send__(:argument, :argument2)
      example_input_object_class.__send__(:argument, :argument3, allow_nil: false)
      example_input_object_class.__send__(:argument, :argument4, allow_blank: false)
    end


    context "when nil arguments are provided with non_nil fields" do
      let(:input) do
        { test_argument1: nil, test_argument2: nil, test_argument3: nil, test_argument4: nil }
      end

      it "raises" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing arguments: test_argument3, test_argument4"
      end
    end

    context "when blanks are provided for required fields" do
      let(:input) do
        { test_argument1: nil, test_argument2: nil, test_argument3: "", test_argument4: "" }
      end

      it "raises" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing argument: test_argument4"
      end
    end

    context "when nil arguments are provided" do
      let(:input) do
        { test_argument1: nil, test_argument2: nil, test_argument3: :test_value3, test_argument4: :test_value4 }
      end

      it "does not raise" do
        expect { example_input_object }.not_to raise_error
      end
    end

    context "when all arguments are provided" do
      let(:input) do
        { test_argument1: :test_value1, test_argument2: :test_value2, test_argument3: :test_value3, test_argument4: :test_value4 }
      end

      it "does not raise" do
        expect { example_input_object }.not_to raise_error
      end
    end

    context "when one argument is omitted" do
      let(:input) do
        { test_argument1: :test_value1, test_argument3: :test_value3, test_argument4: :test_value4 }
      end

      it "raises" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing argument: test_argument2"
      end
    end

    context "when multiple arguments are omitted" do
      let(:input) do
        { test_argument3: :test_value3, test_argument4: :test_value4 }
      end

      it "does not raise" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing arguments: test_argument1, test_argument2"
      end
    end
  end
end
