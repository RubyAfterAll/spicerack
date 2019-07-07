# frozen_string_literal: true

RSpec.describe Spicerack::Configurable do
  subject(:configurable_module) do
    Module.new do
      extend Spicerack::Configurable

      configuration_options do
        option :option_without_default
        option :option_with_default, default: "default value"
        option(:option_with_default_block) { "default value from block" }

        nested :nested_config do
          option :nested_option_without_default
          option :nested_option_with_default, default: "nested default value"
          option(:nested_option_with_default_block) { "nested default value from block" }
        end
      end
    end
  end

  let(:config) { configurable_module.config }

  it { is_expected.to define_config_option(:option_without_default) }
  it { is_expected.to define_config_option(:option_with_default, default: "default value") }
  it { is_expected.to define_config_option(:option_with_default_block, default: "default value from block") }

  it "doesn't define accessors outside of configure block" do
    expect { config.option_without_default = double }.to raise_error NoMethodError
    expect { config.option_with_default = double }.to raise_error NoMethodError
    expect { config.option_with_default_block = double }.to raise_error NoMethodError

    expect { config.nested_config.nested_option_without_default = double }.to raise_error NoMethodError
    expect { config.nested_config.nested_option_with_default = double }.to raise_error NoMethodError
    expect { config.nested_config.nested_option_with_default_block = double }.to raise_error NoMethodError
  end

  context "when runtime configuration has not been set up" do
    it "uses the default values" do
      expect(config.option_without_default).to be_nil
      expect(config.option_with_default).to eq "default value"
      expect(config.option_with_default_block).to eq "default value from block"

      expect(config.nested_config.nested_option_without_default).to be_nil
      expect(config.nested_config.nested_option_with_default).to eq "nested default value"
      expect(config.nested_config.nested_option_with_default_block).to eq "nested default value from block"
    end
  end

  context "when runtime configuration has been set up" do
    let(:option_without_default_override) { "option without default override" }
    let(:option_with_default_override) { "option with default override" }
    let(:option_with_default_block_override) { "option with default block override" }

    let(:nested_option_without_default_override) { "nested option without default override" }
    let(:nested_option_with_default_override) { "nested option with default override" }
    let(:nested_option_with_default_block_override) { "nested option with default block override" }

    before do
      configurable_module.configure do |konfig|
        konfig.option_without_default = option_without_default_override
        konfig.option_with_default = option_with_default_override
        konfig.option_with_default_block = option_with_default_block_override

        konfig.nested_config.nested_option_without_default = nested_option_without_default_override
        konfig.nested_config.nested_option_with_default = nested_option_with_default_override
        konfig.nested_config.nested_option_with_default_block = nested_option_with_default_block_override
      end
    end

    it "sets the override values" do
      expect(configurable_module.config.option_without_default).to eq option_without_default_override
      expect(configurable_module.config.option_with_default).to eq option_with_default_override
      expect(configurable_module.config.option_with_default_block).to eq option_with_default_block_override

      expect(configurable_module.config.nested_config.nested_option_without_default).to eq nested_option_without_default_override
      expect(configurable_module.config.nested_config.nested_option_with_default).to eq nested_option_with_default_override
      expect(configurable_module.config.nested_config.nested_option_with_default_block).to eq nested_option_with_default_block_override
    end
  end
end
