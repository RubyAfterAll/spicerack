# frozen_string_literal: true

RSpec.describe Spicerack::InputObjectBase do
  subject { described_class }

  it { is_expected.to inherit_from Spicerack::AttributeObject }
end
