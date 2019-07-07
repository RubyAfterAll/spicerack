# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::ConfigObject do
  subject(:config) { config_object_class.instance }

  let(:config_object_class) { Class.new(described_class) }

  it { is_expected.to inherit_from Spicerack::InputObject }
  it { is_expected.to include_module Singleton }
end
