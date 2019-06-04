# frozen_string_literal: true

RSpec.describe Spicerack::Configurable, type: :integration do
  subject(:configurable) { example_configurable.new }

  let(:has_default_default_value) { "A default value" }
  let(:example_configurable) { Class.new }

  before do
    example_configurable.instance_exec(has_default_default_value) do |has_default_default_value|
      include Spicerack::Configurable

      configuration_options do
        option :no_default
        option :has_default, default: has_default_default_value
      end
    end
  end


  it { is_expected.to include_module Spicerack::Configurable }

  describe ".configure" do
    it "defines options" do
      example_configurable.configure do |config|
        expect(config).to define_option :no_default
        expect(config).to define_option :has_default, default: has_default_default_value
      end
    end
  end

  describe ".configuration" do
    context "when values are set" do
      let(:has_default_value) { Faker::Lorem.word }
      let(:no_default_value) { Faker::Lorem.word }

      before do
        example_configurable.configure do |config|
          config.no_default = no_default_value
          config.has_default = has_default_value
        end
      end

      it "sets the config variables" do
        expect(example_configurable.configuration.no_default).to eq no_default_value
        expect(example_configurable.configuration.has_default).to eq has_default_value
      end
    end

    context "when no values are set" do
      it "has the default values, or nil" do
        expect(example_configurable.configuration.no_default).to eq nil
        expect(example_configurable.configuration.has_default).to eq has_default_default_value
      end
    end
  end

  describe "writers" do
    it "doesn't set writers for the config options" do
      expect { example_configurable.configuration.no_default = Faker::Lorem.word }.to raise_error(NoMethodError)
      expect { example_configurable.configuration.has_default = Faker::Lorem.word }.to raise_error(NoMethodError)
    end
  end
end
