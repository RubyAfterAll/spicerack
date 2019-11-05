# frozen_string_literal: true

RSpec.describe Conjunction::Prototype, type: :prototype do
  include_context "with an example prototype"

  it { is_expected.to delegate_method(:prototype_name).to(:class) }

  describe "#prototype!" do
    subject(:prototype!) { example_prototype.prototype! }

    context "when prototype returns nil" do
      before { allow(example_prototype).to receive(:prototype).and_return(nil) }

      it "raises" do
        expect { prototype! }.to raise_error NameError, "#{example_prototype_name} is not defined"
      end
    end

    context "when prototype returns something" do
      it { is_expected.to eq example_prototype.prototype }
    end
  end

  describe "#prototype" do
    subject { example_prototype.prototype }

    it { is_expected.to eq example_prototype_class }
  end

  describe ".prototype_name" do
    subject { example_prototype_class.prototype_name }

    context "with model_name" do
      let(:prototype_name) { SecureRandom.hex }
      let(:model_name) { double(name: prototype_name) }

      before { allow(example_prototype_class).to receive(:model_name).and_return(model_name) }

      it { is_expected.to eq prototype_name }
    end

    context "without model_name" do
      it { is_expected.to eq example_prototype_name }
    end
  end
end
