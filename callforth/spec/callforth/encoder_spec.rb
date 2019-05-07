# frozen_string_literal: true

RSpec.describe Callforth::Encoder do
  include_context "with target class having method"

  describe ".encode" do
    it_behaves_like "a class pass method", :encode
  end

  describe "#initialize" do
    context "with no optional arguments" do
      let(:class_arguments) { nil }
      let(:method_arguments) { nil }

      subject { described_class.new(target_class, method) }

      it_behaves_like "an encoder"
    end

    context "with class_arguments" do
      subject { described_class.new(target_class, method, class_arguments: class_arguments) }

      let(:method_arguments) { nil }

      it_behaves_like "an encoder"
    end

    context "with method_arguments" do
      subject { described_class.new(target_class, method, method_arguments: method_arguments) }

      let(:class_arguments) { nil }

      it_behaves_like "an encoder"
    end

    context "with both optional arguments" do
      subject do
        described_class.new(target_class, method, class_arguments: class_arguments, method_arguments: method_arguments)
      end

      it_behaves_like "an encoder"
    end
  end
end
