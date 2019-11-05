# frozen_string_literal: true

RSpec.describe Conjunction do
  it_behaves_like "a versioned spicerack gem"

  describe described_class::Error do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::DisjointedError do
    it { is_expected.to inherit_from Conjunction::Error }
  end
end
