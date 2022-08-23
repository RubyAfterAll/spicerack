# frozen_string_literal: true

RSpec.describe Tablesalt::ClassPass, type: :module do
  let(:example_dsl_class) do
    Class.new.instance_exec(self) do |spec|
      include spec.described_class

      class_pass_method spec.method_name

      attr_reader :a, :b

      class_exec(spec, &spec.define_instance_method)
      class_exec(spec, &spec.define_initialize)

      self
    end
  end

  describe ".class_pass_method" do
    subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs) }

    let(:args) { [] }
    let(:kwargs) { {} }

    let(:method_name) { Faker::Hipster.unique.word }
    let(:attributes) { Array.new(2) { |i| double("attribute #{i}") } }

    let(:example_instance) do
      # TODO: remove top branch when ruby 2.7 support is removed
      if args.empty? && kwargs.empty?
        example_dsl_class.new

      # TODO: remove this branch when ruby 2.6 support is removed
      elsif kwargs.empty? && RUBY_VERSION < "2.7.0"
        example_dsl_class.new(*args)
      else
        example_dsl_class.new(*args, **kwargs)
      end
    end

    let(:define_instance_method) do
      proc do |spec|
        define_method(spec.method_name) { [ a, b ] }
      end
    end

    before do
      if args.blank? && kwargs.blank?
        allow(example_dsl_class).to receive(:new).with(no_args).and_return(example_instance)

      # TODO: remove this branch when ruby 2.6 support is removed
      elsif kwargs.blank? && RUBY_VERSION < "2.7.0"
        allow(example_dsl_class).to receive(:new).with(*args).and_return(example_instance)
      else
        allow(example_dsl_class).to receive(:new).with(*args, **kwargs).and_return(example_instance)
      end

      allow(example_instance).to receive(method_name).and_call_original
    end

    shared_context "when the method accepts a block" do
      let(:block) { -> { block_return_value } }
      let(:block_return_value) { double("block return value") }

      let(:define_instance_method) do
        proc do |spec|
          define_method(spec.method_name) do |&block|
            block.call
          end
        end
      end
    end

    context "when the class accepts kwargs" do
      let(:kwargs) { { a: attributes.first, b: attributes.last } }

      let(:define_initialize) do
        proc do
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
        expect(example_instance).to have_received(method_name).with(no_args)
      end

      context "when a block is given" do
        subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs, &block) }

        include_context "when the method accepts a block"

        it { is_expected.to eq block_return_value }
      end
    end

    context "when the class accepts args" do
      let(:args) { attributes }

      let(:define_initialize) do
        proc do
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
        expect(example_instance).to have_received(method_name).with(no_args)
      end

      context "when a block is given" do
        subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs, &block) }

        include_context "when the method accepts a block"

        it { is_expected.to eq block_return_value }
      end
    end

    context "when the class accepts mixed args" do
      let(:args) { [ attributes.first ] }
      let(:kwargs) { { b: attributes.last } }

      let(:define_initialize) do
        proc do
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
        expect(example_instance).to have_received(method_name).with(no_args)
      end

      context "when a block is given" do
        subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs, &block) }

        include_context "when the method accepts a block"

        it { is_expected.to eq block_return_value }
      end
    end

    context "when the class accepts no args" do
      let(:define_initialize) do
        proc do
          def initialize; end
        end
      end

      it { is_expected.to eq [ nil, nil ] }

      it "initializes with the provided params" do
        class_pass
        expect(example_dsl_class).to have_received(:new).with(no_args)
        expect(example_instance).to have_received(method_name).with(no_args)
      end

      context "when a block is given" do
        subject(:class_pass) { example_dsl_class.public_send(method_name, *args, **kwargs, &block) }

        include_context "when the method accepts a block"

        it { is_expected.to eq block_return_value }
      end
    end
  end
end
