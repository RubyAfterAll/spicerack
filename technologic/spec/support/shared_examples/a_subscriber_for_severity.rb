# frozen_string_literal: true

RSpec.shared_examples_for "a subscriber for severity" do |severity|
  subject { described_class }

  it { is_expected.to inherit_from Technologic::Subscriber::Base }

  describe ".name" do
    subject { described_class.name.demodulize }

    it { is_expected.to eq "#{severity.to_s.capitalize}Subscriber" }
  end

  describe ".severity" do
    subject { described_class.severity }

    it { is_expected.to eq severity }
  end
end
