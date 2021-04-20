# frozen_string_literal: true

RSpec.describe Substance::OutputObject do
  subject { described_class }

  it { is_expected.to inherit_from Substance::InputModel }

  it { is_expected.to include_module Substance::Objects::Status }
  it { is_expected.to include_module Substance::Objects::Output }
end
