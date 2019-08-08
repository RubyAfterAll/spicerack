# frozen_string_literal: true

RSpec.describe Collectible::CollectionBase do
  it { is_expected.to include_module Tablesalt::StringableObject }
end
