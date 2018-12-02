# frozen_string_literal: true

RSpec.shared_examples_for "a versioned spicerack gem" do
  it "has a version number" do
    expect(described_class::VERSION).to be_a String
    expect(described_class::VERSION).not_to be_blank
    expect(described_class::VERSION).to eq Spicerack::VERSION
  end
end
