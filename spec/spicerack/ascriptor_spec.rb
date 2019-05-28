# frozen_string_literal: true

RSpec.describe Spicerack::Ascriptor do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::RootObject }
end
