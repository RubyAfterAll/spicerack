# frozen_string_literal: true

RSpec.describe PlanetaryAddress, type: :schmodel do
  it { is_expected.to inherit_from ApplicationSchmodel }

  it { is_expected.to have_prototype described_class }
  it { is_expected.to have_prototype_name "PlanetaryAddress" }
  it { is_expected.to conjugate_into PlanetaryAddressFleeb }
end
