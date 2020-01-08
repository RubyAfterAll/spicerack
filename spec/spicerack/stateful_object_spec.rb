# frozen_string_literal: true

RSpec.describe Spicerack::StatefulObject do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::InputModel }
end
