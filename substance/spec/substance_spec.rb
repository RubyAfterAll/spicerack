# frozen_string_literal: true

RSpec.describe Substance do
  it "has a version number" do
    expect(Substance::VERSION).not_to be nil
  end

  describe described_class::Error do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::NotValidatedError do
    it { is_expected.to inherit_from Substance::Error }
  end
end
