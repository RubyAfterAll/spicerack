# frozen_string_literal: true

RSpec.describe GalacticFederation::Satellite, type: :poro do
  it { is_expected.to inherit_from ApplicationPoro }

  it { is_expected.to have_prototype_name "GalacticFederation::Satellite" }
end
