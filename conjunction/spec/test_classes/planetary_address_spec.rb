# frozen_string_literal: true

RSpec.describe PlanetaryAddress, type: :schmodel do
  it { is_expected.to inherit_from ApplicationSchmodel }

  it { is_expected.to have_prototype_name "PlanetaryAddress" }
end
