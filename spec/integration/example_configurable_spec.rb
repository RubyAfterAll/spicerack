# frozen_string_literal: true

RSpec.describe ExampleConfigurable, type: :integration do
  subject(:configurable) { described_class.new }

  it { is_expected.to include_module Spicerack::Configurable }

  describe ".config_class" do
    subject { described_class.__send__(:config_class) }

    it { is_expected.to define_option :no_default }
    it { is_expected.to define_option :has_default, default: "A default value" }
  end
end
