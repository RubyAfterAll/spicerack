# frozen_string_literal: true

RSpec.describe AroundTheWorld do
  # NOTE: if :sample_method gets changed to something else,
  # you must change the definitions in the sample classes as well,
  let(:wrapped_method_name) { :sample_method }
  let(:prevent_double_wrapping_purpose) { nil }
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
    subject(:around) do
      sample_class.__send__(
        :around_method,
        wrapped_method_name,
        prevent_double_wrapping_for: prevent_double_wrapping_purpose,
      ) {}
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
        it "adds another prepended module" do
          ancestors_before = sample_class.ancestors
          expect { around }.to change { sample_class.ancestors.count }.by(1)
          expect((sample_class.ancestors - ancestors_before).first).to be_a described_class::ProxyModule
        end
      end

      context "when prevent_double_wrapping_for is set" do
        let(:prevent_double_wrapping_purpose) { Faker::Lorem.word }

        it "raises an error" do
          expect { around }.to raise_error described_class::DoubleWrapError
        end
      end
    end

    context "when method has not been defined on the specified module" do
      it "needs specs"
    end
  end
end
