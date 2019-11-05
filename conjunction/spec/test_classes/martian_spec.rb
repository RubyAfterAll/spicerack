# frozen_string_literal: true

RSpec.describe Martian, type: :schmodel do
  it { is_expected.to inherit_from ApplicationSchmodel }

  it { is_expected.to have_prototype_name "Martian" }

  it { is_expected.to conjugate_into Chumble::Martian }
end
