# frozen_string_literal: true

require_relative "example_classes/example_called_class"

RSpec.describe AroundTheWorld do
  subject { receiver }

  let(:receiver) { example_wrapped_class.new }
  let(:example_wrapped_class) { Class.new.tap { |klass| klass.include(described_class) } }

  it { is_expected.to include_module described_class }

  shared_examples_for "a wrapped method" do
    let(:around_method_receiver) { receiver.is_a?(Module) ? receiver.singleton_class : receiver.class }

    let(:wrapped_method_name) { Faker::Lorem.sentence.parameterize.underscore }
    let(:return_value) { double }

    let(:primary_args) { Faker::Hipster.words }
    let(:secondary_args) { Faker::Lorem.words }

    let(:define_wrapped_method_proc) do
      lambda do |spec_context|
        define_method(spec_context.wrapped_method_name) do |*args|
          ExampleCalledClass.primary(*args)

          spec_context.return_value
        end
      end
    end

    let(:wrapper_method_proc) do
      lambda do |spec_context|
        around_method spec_context.wrapped_method_name do |*args|
          ExampleCalledClass.secondary(*spec_context.secondary_args)

          super(*args)
        end
      end
    end

    let(:wrap_method!) { around_method_receiver.instance_exec(self, &wrapper_method_proc) }
    let(:wrap_method?) { false }

    before do
      around_method_receiver.instance_exec(self, &define_wrapped_method_proc)

      wrap_method! if wrap_method?

      allow(ExampleCalledClass).to receive(:primary)
      allow(ExampleCalledClass).to receive(:secondary)
    end

    context "when wrapped method is called" do
      before do
        receiver.public_send(wrapped_method_name, *primary_args)
      end

      it "calls the primary method" do
        expect(ExampleCalledClass).to have_received(:primary).with(*primary_args)
      end

      it "does not call the secondary method" do
        expect(ExampleCalledClass).not_to have_received(:secondary)
      end

      context "when the method is wrapped" do
        let(:wrap_method?) { true }

        it "calls the primary method" do
          expect(ExampleCalledClass).to have_received(:primary).with(*primary_args)
        end

        it "returns the expected return value" do
          expect(receiver.public_send(wrapped_method_name)).to eq return_value
        end

        it "calls the secondary method" do
          expect(ExampleCalledClass).to have_received(:secondary).with(*secondary_args)
        end

        context "when wrapper method does not return the return value" do
          subject { receiver.public_send(wrapped_method_name) }

          let(:different_return_value) { double }

          let(:wrapper_method_proc) do
            lambda do |spec_context|
              around_method spec_context.wrapped_method_name do |*args|
                ExampleCalledClass.secondary(*spec_context.secondary_args)

                super(*args)

                spec_context.different_return_value
              end
            end
          end

          it { is_expected.to eq different_return_value }
          it { is_expected.not_to eq return_value }
        end
      end
    end
  end

  context "when receiver is an instance" do
    let(:receiver) { example_wrapped_class.new }

    it_behaves_like "a wrapped method"
  end

  context "when receiver is a class" do
    let(:receiver) { example_wrapped_class }

    it_behaves_like "a wrapped method"
  end
end
