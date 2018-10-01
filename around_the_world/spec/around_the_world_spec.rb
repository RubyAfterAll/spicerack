# frozen_string_literal: true

RSpec.describe AroundTheWorld do
  # NOTE: if :sample_method gets changed to something else, you must change the definitions in the sample classes as well
  let(:wrapped_method_name) { :sample_method }
  let(:prepended_module_name) { "PrependedModule" }
  let(:sample_class_response) { Faker::Hipster.sentence }

  let(:sample_class) do
    Class.new do
      include AroundTheWorld

      def sample_method
        # TODO: Do something testable here
      end
    end
  end

  let(:sample_inheriting_class_response) { Faker::ChuckNorris.fact }
  let(:sample_inheriting_class) do
    Class.new do
      def sample_method
        # TODO: Do something testable here
      end
    end
  end

  it "has a version number" do
    expect(AroundTheWorld::VERSION).not_to be nil
  end

  describe ".around_method" do
    subject(:around) { sample_class.__send__(:around_method, wrapped_method_name, prepended_module_name) { } }

    context "when class has no name" do
      it "raises an error" do
        expect { around }.to raise_error NameError
      end
    end

    context "when class has a name" do
      before do
        stub_const("SampleAroundMethodClass", sample_class)
        stub_const("SampleInheritingAroundMethodClass", sample_inheriting_class)
      end

      context "when method has been defined on the specified module already" do
        before do
          sample_class.__send__(:around_method, wrapped_method_name, prepended_module_name) {}
        end

        it "raises an error" do
          expect { around }.to raise_error described_class::DoubleWrapError
        end
      end

      context "when method has not been defined on the specified module" do
        it "needs specs"
      end
    end
  end
end
