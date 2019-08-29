# frozen_string_literal: true

RSpec.describe BottleFacet, type: :facet do
  it { is_expected.to inherit_from Facet::Base }
  # it { is_expected.to have_record_class ... }
  # it { is_expected.to have_record_scope ... }
  # it { is_expected.to have_default_filter }
  # it { is_expected.to have_default_sort }
  # it { is_expected.to have_default_page }
end
