# frozen_string_literal: true

RSpec.describe Facet::Base do
  it { is_expected.to include_module ShortCircuIt }

  it { is_expected.to include_module Facet::Record }
  it { is_expected.to include_module Facet::Paginate }
  it { is_expected.to include_module Facet::Filter }
  it { is_expected.to include_module Facet::Sort }
  it { is_expected.to include_module Facet::Core }
  it { is_expected.to include_module Facet::Collection }
  it { is_expected.to include_module Facet::Cache }
end
