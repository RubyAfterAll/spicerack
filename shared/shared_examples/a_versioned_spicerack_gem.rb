# frozen_string_literal: true

# RSpec example that ensures gem compliance with internal standard of [Spicerack](https://github.com/Freshly/spicerack/)
#
#     RSpice.describe MyAwesomeGem do
#       it_behaves_like "a versioned spicerack gem"
#     end

RSpec.shared_examples_for "a versioned spicerack gem" do
  it "has a version number" do
    expect(described_class::VERSION).to be_a String
    expect(described_class::VERSION).not_to be_blank
    expect(described_class::VERSION).to eq Spicerack::VERSION
  end
end
