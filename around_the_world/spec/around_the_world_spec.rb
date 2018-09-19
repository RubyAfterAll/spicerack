# frozen_string_literal: true

RSpec.describe AroundTheWorld do
  let(:sample_class_response) { Faker::Hipster.sentence }
  let(:sample_class) do
    Class.new do
      include AroundMethod

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
    context "when class has no name" do
      subject(:around) { sample_class.__send__(:around_method, :sample_method, "RandomModule") { } }

      it "raises an error" do
        expect { around }.to raise_error NameError
      end
    end

    context "when class has a name" do
      before do
        stub_const("SampleAroundMethodClass", sample_class)
        stub_const("SampleInheritingAroundMethodClass", sample_inheriting_class)

        # sample_class.
      end
    end
  end
end
