# frozen_string_literal: true

RSpec.describe HighFrequencyRadioBurst, type: :poro do
  it { is_expected.to inherit_from ApplicationPoro }

  it { is_expected.to have_prototype_name "HighFrequencyRadioBurst" }
  it { is_expected.to be_conjoined_to GenericFleeb }
  it { is_expected.to conjugate_into GenericFleeb }
end
