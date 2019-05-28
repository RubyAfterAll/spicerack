# frozen_string_literal: true

RSpec.describe Ascriptor::Base, type: :instructor do
  subject { described_class }

  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Tablesalt::StringableObject }
end
