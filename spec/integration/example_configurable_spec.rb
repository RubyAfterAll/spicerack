# frozen_string_literal: true

RSpec.describe ExampleConfigurable, type: :integration do
  subject(:configurable) { described_class.new }

  let(:has_default_default_value) { "A default value" }

  after do
    described_class.remove_instance_variable(:@config) if described_class.instance_variables.include?(:@config)
  end

  it { is_expected.to include_module Spicerack::Configurable }

  describe ".config_class" do
    subject { described_class.__send__(:config_class) }

    it { is_expected.to define_option :no_default }
    it { is_expected.to define_option :has_default, default: has_default_default_value }
  end

  describe ".configure" do
    context "when values are set" do
      let(:has_default_value) { Faker::Lorem.word }
      let(:no_default_value) { Faker::Lorem.word }

      before do
        described_class.configure do |config|
          config.no_default = no_default_value
          config.has_default = has_default_value
        end
      end

      it "sets the config variables" do
        expect(described_class.no_default).to eq no_default_value
        expect(described_class.has_default).to eq has_default_value
      end
    end

    context "when no values are set" do
      it "has the default values, or nil" do
        expect(described_class.no_default).to eq nil
        expect(described_class.has_default).to eq has_default_default_value
      end
    end
  end

  describe ".config" do
    subject { described_class.private_methods }

    it { is_expected.to include :config }
  end

  describe "writers" do
    it "doesn't set writers for the config options" do
      expect { described_class.no_default = Faker::Lorem.word }.to raise_error(NoMethodError)
      expect { described_class.has_default = Faker::Lorem.word }.to raise_error(NoMethodError)
    end
  end
end
