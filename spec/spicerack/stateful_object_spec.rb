# frozen_string_literal: true

RSpec.describe Spicerack::StatefulObject do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::InputModel }

  it { is_expected.to include_module Spicerack::Objects::Status }
  it { is_expected.to include_module Spicerack::Objects::Output }
end
