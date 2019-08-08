# frozen_string_literal: true

RSpec.describe Collectible::CollectionBase do
  it { is_expected.to include_module Tablesalt::StringableObject }
  it { is_expected.to include_module Tablesalt::UsesHashForEquality }

  it { is_expected.to include_module Collectible::Collection::Core }
end

