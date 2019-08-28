# frozen_string_literal: true

RSpec.describe Facet::Base do
  it { is_expected.to include_module Facet::Filter }
  it { is_expected.to include_module Facet::Sort }
  it { is_expected.to include_module Facet::Core }
end
