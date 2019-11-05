# frozen_string_literal: true

RSpec.describe Starlight, type: :poro do
  it { is_expected.to inherit_from ApplicationPoro }

  it { is_expected.to have_prototype_name "Starlight" }
end
