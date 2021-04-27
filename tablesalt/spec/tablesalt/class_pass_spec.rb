# frozen_string_literal: true

RSpec.describe Tablesalt::ClassPass, type: :module do
  subject(:example_object) { example_dsl_class.new }

  let(:example_dsl_class) do
    Class.new.instance_exec(self) do |spec|
      include spec.described_class

      class_pass_method spec.method_name

      attr_reader :a, :b

      define_method(spec.method_name) { [ a, b ] }

      self
    end
  end

  describe ".class_pass_method" do
    subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs) }

    let(:args) { [] }
    let(:kwargs) { {} }

    let(:method_name) { Faker::Hipster.unique.word }
    let(:attributes) { Array.new(2) { double } }

    before do
      allow(example_dsl_class).to receive(:new).and_call_original
    end

    context "when the class accepts kwargs" do
      let(:kwargs) { { a: attributes.first, b: attributes.last } }

      before do
        example_dsl_class.class_exec do
          def initialize(a:, b:)
            @a = a
            @b = b
          end
        end
      end

      it { is_expected.to eq attributes }

      it "initializes with the provided params" do
        class_pass
        expect(example_dsl_class).to have_received(:new).with(a: attributes.first, b: attributes.last)
      end
    end

    context "when the class accepts args" do
      let(:args) { attributes }

      before do
        example_dsl_class.class_exec do
          def initialize(a, b)
            @a = a
            @b = b
          end
        end
      end

      it { is_expected.to eq attributes }

      it "initializes with the provided params" do
        class_pass
        expect(example_dsl_class).to have_received(:new).with(*attributes)
      end
    end

    context "when the class accepts mixed args" do
      let(:args) { [ attributes.first ] }
      let(:kwargs) { { b: attributes.last } }

      before do
        example_dsl_class.class_exec do
          def initialize(a, b:)
            @a = a
            @b = b
          end
        end
      end

      it { is_expected.to eq attributes }

      it "initializes with the provided params" do
        class_pass
        expect(example_dsl_class).to have_received(:new).with(attributes.first, b: attributes.last)
      end
    end

    context "when the class accepts no args" do
      before do
        example_dsl_class.class_exec do
          def initialize; end
        end
      end

      it { is_expected.to eq [ nil, nil ] }

      it "initializes with the provided params" do
        class_pass
        expect(example_dsl_class).to have_received(:new).with(no_args)
      end
    end
  end
end
