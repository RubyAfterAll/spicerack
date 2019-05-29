# frozen_string_literal: true

RSpec.describe Spicerack::AscriptorBase do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::RootObject }
  it { is_expected.to include_module Spicerack::Ascriptor::Defaults }
end
