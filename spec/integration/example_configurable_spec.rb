# frozen_string_literal: true

RSpec.describe ExampleConfigurable, type: :integration do
  it { is_expected.to include_module Spicerack::Configurable }
end
