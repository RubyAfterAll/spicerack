# frozen_string_literal: true

RSpec.describe Callforth do
  it_behaves_like "a versioned spicerack gem"

  describe ".encode" do
    it_behaves_like "a class pass method", :encode do
      let(:test_class) { described_class::Encoder }
    end
  end
end
