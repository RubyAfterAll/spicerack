# frozen_string_literal: true

RSpec.describe Substance::AttributeObject do
  subject { described_class }

  it { is_expected.to inherit_from Substance::RootObject }
  it { is_expected.to include_module Substance::Objects::Defaults }
  it { is_expected.to include_module Substance::Objects::Attributes }
end
