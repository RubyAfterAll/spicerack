# frozen_string_literal: true

RSpec.describe Luna, type: :luna do
  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }

  it { is_expected.to have_prototype_name "Luna" }
end
