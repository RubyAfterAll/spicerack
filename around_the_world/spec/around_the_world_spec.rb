# frozen_string_literal: true

RSpec.describe AroundTheWorld do
  let(:wrapped_method_name) { :sample_method }
  let(:prevent_double_wrapping_purpose) { nil }
  let(:sample_class_response) { Faker::Hipster.sentence }
  let(:proxy_module) { sample_class.ancestors.find { |mod| mod.is_a?(described_class::ProxyModule) } }

  let(:sample_class) do
    Class.new.tap do |klass|
      klass.instance_exec(described_class, wrapped_method_name) do |described_class, wrapped_method_name|
        include described_class

        define_method(wrapped_method_name) do
          # TODO: Do something testable here
        end
      end
    end
  end

  it "has a version number" do
    expect(AroundTheWorld::VERSION).not_to be nil
  end

  describe ".around_method" do
    subject(:around) do
      sample_class.__send__(
        :around_method,
        wrapped_method_name,
        prevent_double_wrapping_for: prevent_double_wrapping_purpose,
      ) {}
    end

    context "when the target does not define the wrapped method" do
      before { sample_class.undef_method(wrapped_method_name) }

      it "raises" do
        expect { around }.to raise_error AroundTheWorld::MethodNotDefinedError
      end
    end

    context "when the method is protected" do
      subject { proxy_module }

      before do
        sample_class.__send__(:protected, wrapped_method_name)
        around
      end

      it { is_expected.to be_protected_method_defined wrapped_method_name }
    end

    context "when the method is private" do
      subject { proxy_module }

      before do
        sample_class.__send__(:private, wrapped_method_name)
        around
      end

      it { is_expected.to be_private_method_defined wrapped_method_name }
    end

    context "when method has been defined on the specified module already" do
      before do
        sample_class.__send__(
          :around_method,
          wrapped_method_name,
          prevent_double_wrapping_for: prevent_double_wrapping_purpose,
        ) {}
      end

      context "when prevent_double_wrapping_for is not set" do
        context "when prepend_module_name is set" do
          subject(:around) { sample_class.__send__(:around_method, wrapped_method_name, prepend_module_name) {} }

          let(:prepend_module_name) { Faker::Lorem.word }

          before { sample_class.__send__(:around_method, wrapped_method_name, prepend_module_name) {} }

          it "raises" do
            expect { around }.to raise_error described_class::DoubleWrapError
          end
        end

        context "when prepend_module_name is not set" do
          it "adds another prepended module" do
            ancestors_before = sample_class.ancestors
            expect { around }.to change { sample_class.ancestors.count }.by(1)
            expect((sample_class.ancestors - ancestors_before).first).to be_a described_class::ProxyModule
          end
        end
      end

      context "when prevent_double_wrapping_for is set" do
        let(:prevent_double_wrapping_purpose) { Faker::Lorem.word }

        it "raises" do
          expect { around }.to raise_error described_class::DoubleWrapError
        end
      end
    end

    context "when method has not been defined on the specified module" do
      it "needs specs"
    end
  end
end
