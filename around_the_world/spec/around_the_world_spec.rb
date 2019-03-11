# frozen_string_literal: true

RSpec.describe AroundTheWorld do
  let(:prevent_double_wrapping_purpose) { nil }
  let(:proxy_module) { wrapped_class.ancestors.find { |mod| mod.is_a?(described_class::ProxyModule) } }
  let(:wrapped_method_name) { :sample_method }
  let(:private_method_name) { :some_private_method }
  let(:wrapped_method_return_value) { Faker::Hipster.sentence }
  let(:wrapped_instance) { wrapped_class.new }
  let(:wrapped_class) do
    Class.new.tap do |klass|
      klass.instance_exec(self) do |spec_context|
        include spec_context.described_class

        define_method(spec_context.wrapped_method_name) do |*args|
          __send__(spec_context.private_method_name, *args)
        end

        private

        define_method(spec_context.private_method_name) do |*_args|
          spec_context.wrapped_method_return_value
        end
      end
    end
  end

  let(:wrap_method) do
    wrapped_class.__send__(
      :around_method,
      wrapped_method_name,
      prevent_double_wrapping_for: prevent_double_wrapping_purpose,
      &wrapper_proc
    )
  end

  before { allow(wrapped_instance).to receive(private_method_name).and_call_original }

  it_behaves_like "a versioned spicerack gem"

  describe ".around_method" do
    subject(:around) { wrap_method }

    let(:wrapper_proc) { -> {} }

    context "when the target does not define the wrapped method" do
      before { wrapped_class.undef_method(wrapped_method_name) }

      it "raises" do
        expect { around }.to raise_error AroundTheWorld::MethodNotDefinedError
      end
    end

    context "when the method is protected" do
      subject { proxy_module }

      before do
        wrapped_class.__send__(:protected, wrapped_method_name)
        around
      end

      it { is_expected.to be_protected_method_defined wrapped_method_name }
    end

    context "when the method is private" do
      subject { proxy_module }

      before do
        wrapped_class.__send__(:private, wrapped_method_name)
        around
      end

      it { is_expected.to be_private_method_defined wrapped_method_name }
    end

    context "when method has been wrapped already" do
      subject(:around) do
        wrapped_class.__send__(
          :around_method,
          wrapped_method_name,
          prevent_double_wrapping_for: prevent_double_wrapping_purpose,
          &wrapper_proc
        )
      end

      before { wrap_method }

      context "when prevent_double_wrapping_for is not set" do
        it "adds another prepended module" do
          ancestors_before = wrapped_class.ancestors
          expect { around }.to change { wrapped_class.ancestors.count }.by(1)
          expect((wrapped_class.ancestors - ancestors_before).first).to be_a described_class::ProxyModule
        end
      end

      context "when prevent_double_wrapping_for is set" do
        let(:prevent_double_wrapping_purpose) { Faker::Lorem.word }

        it "raises" do
          expect { around }.to raise_error described_class::DoubleWrapError
        end
      end

      context "when another method is wrapped" do
        let(:another_method_name) { "#{wrapped_method_name}xyz" }

        before do
          wrapped_class.define_method(another_method_name) { rand(1234) }
        end

        it "uses the same proxy module" do
          expect { wrapped_class.__send__(:around_method, another_method_name) {} }.
            not_to(change { wrapped_class.ancestors.length })
        end
      end
    end

    shared_context "with stubbed side effect class" do
      let(:method_call_args) { Faker::Hipster.words }

      let(:external_method_name) { :side_effect }
      let(:external_method_return_value) { Faker::ChuckNorris.fact }
      let(:another_class) { OpenStruct.new(external_method_name => nil) }

      before do
        stub_const("AnotherClass", another_class)
        allow(another_class).to receive(external_method_name).and_return(external_method_return_value)
      end
    end

    shared_context "when method is wrapped" do
      subject(:wrapped_method) { wrapped_instance.public_send(wrapped_method_name, *method_call_args) }

      include_context "with stubbed side effect class"

      before { around }
    end

    context "when the wrapper block calls super" do
      include_context "when method is wrapped"

      shared_examples_for "it calls both methods" do
        it "calls both methods" do
          expect(wrapped_method).to eq returned_value
          expect(wrapped_instance).to have_received(private_method_name).with(*method_call_args)
          expect(another_class).to have_received(external_method_name).with(wrapped_instance, *method_call_args)
        end
      end

      context "when the wrapper block returns super" do
        let(:wrapper_proc) do
          lambda do |*args|
            AnotherClass.public_send(:side_effect, self, *args)
            super(*args)
          end
        end

        it_behaves_like "it calls both methods" do
          let(:returned_value) { wrapped_method_return_value }
        end
      end

      context "when the wrapper block returns something else" do
        let(:wrapper_proc) do
          lambda do |*args|
            super(*args)
            AnotherClass.public_send(:side_effect, self, *args)
          end
        end

        it_behaves_like "it calls both methods" do
          let(:returned_value) { external_method_return_value }
        end
      end
    end

    context "when the wrapping block does NOT call super" do
      include_context "when method is wrapped"

      let(:wrapper_proc) do
        lambda do |*args|
          AnotherClass.public_send(:side_effect, self, *args)
        end
      end

      it "doesn't call the wrapped method" do
        expect(wrapped_method).to eq external_method_return_value
        expect(wrapped_instance).not_to have_received(private_method_name)
        expect(another_class).to have_received(external_method_name).with(wrapped_instance, *method_call_args)
      end
    end
  end
end
