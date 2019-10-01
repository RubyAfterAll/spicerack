# frozen_string_literal: true

module ExampleConfigurableClass; end

RSpec.describe ExampleConfigurableClass, type: :configuration do
  subject(:configurable_module) do
    Module.new do
      extend Spicerack::Configurable

      configuration_options do
        option :option_without_default
        option :option_with_default, default: "default value"
        option(:option_with_default_block) { "default value from block" }

        option :option_without_default_to_assign
        option :option_with_default_to_assign, default: "default value to assign"
        option(:option_with_default_block_to_assign) { "default value from block to assign" }

        nested :nested_config do
          option :nested_option_without_default
          option :nested_option_with_default, default: "nested default value"
          option(:nested_option_with_default_block) { "nested default value from block" }

          option :nested_option_without_default_to_assign
          option :nested_option_with_default_to_assign, default: "nested default value to assign"
          option(:nested_option_with_default_block_to_assign) { "nested default value from block to assign" }

          nested :double_nested do
            option :double_nested_option_without_default
            option :double_nested_option_with_default, default: "double nested default value"
            option(:double_nested_option_with_default_block) { "double nested default value from block" }
          end
        end
      end
    end
  end

  let(:described_class) { configurable_module }
  let(:config) { configurable_module.config }

  it { is_expected.to define_config_option(:option_without_default) }
  it { is_expected.to define_config_option(:option_with_default, default: "default value") }
  it { is_expected.to define_config_option(:option_with_default_block, default: "default value from block") }

  it { is_expected.to define_config_option(:option_without_default_to_assign) }
  it { is_expected.to define_config_option(:option_with_default_to_assign, default: "default value to assign") }
  it { is_expected.to define_config_option(:option_with_default_block_to_assign, default: "default value from block to assign") }

  nested_config_option :nested_config do
    it { is_expected.to define_config_option(:nested_option_without_default) }
    it { is_expected.to define_config_option(:nested_option_with_default, default: "nested default value") }
    it { is_expected.to define_config_option(:nested_option_with_default_block, default: "nested default value from block") }

    it { is_expected.to define_config_option(:nested_option_without_default_to_assign) }
    it { is_expected.to define_config_option(:nested_option_with_default_to_assign, default: "nested default value to assign") }
    it { is_expected.to define_config_option(:nested_option_with_default_block_to_assign, default: "nested default value from block to assign") }

    nested_config_option :double_nested do
      it { is_expected.to define_config_option(:double_nested_option_without_default) }
      it { is_expected.to define_config_option(:double_nested_option_with_default, default: "double nested default value") }
      it { is_expected.to define_config_option(:double_nested_option_with_default_block, default: "double nested default value from block") }
    end
  end

  describe "config writers" do
    describe "root config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.option_without_default = double }.to raise_error NoMethodError
        expect { config.option_with_default = double }.to raise_error NoMethodError
        expect { config.option_with_default_block = double }.to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.assign }.to raise_error NoMethodError
        expect { config.assign_attributes }.to raise_error NoMethodError
      end
    end

    describe "nested config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.nested_config.nested_option_without_default = double }.to raise_error NoMethodError
        expect { config.nested_config.nested_option_with_default = double }.to raise_error NoMethodError
        expect { config.nested_config.nested_option_with_default_block = double }.to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.nested_config.assign }.to raise_error NoMethodError
        expect { config.nested_config.assign_attributes }.to raise_error NoMethodError
      end
    end

    describe "deeply nested config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.nested_config.double_nested.double_nested_option_without_default = double }.
          to raise_error NoMethodError
        expect { config.nested_config.double_nested.double_nested_option_with_default = double }.
          to raise_error NoMethodError
        expect { config.nested_config.double_nested.double_nested_option_with_default_block = double }.
          to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.nested_config.double_nested.assign }.to raise_error NoMethodError
        expect { config.nested_config.double_nested.assign_attributes }.to raise_error NoMethodError
      end
    end
  end

  context "when runtime configuration has not been set up" do
    describe "root config vars" do
      it "uses the default values" do
        expect(config.option_without_default).to be_nil
        expect(config.option_with_default).to eq "default value"
        expect(config.option_with_default_block).to eq "default value from block"

        expect(configurable_module.config_eval(:option_without_default).read).to be_nil
        expect(configurable_module.config_eval(:option_with_default).read).to eq "default value"
        expect(configurable_module.config_eval(:option_with_default_block).read).to eq "default value from block"
      end
    end

    describe "nested config vars" do
      it "uses the default values" do
        expect(config.nested_config.nested_option_without_default).to be_nil
        expect(config.nested_config.nested_option_with_default).to eq "nested default value"
        expect(config.nested_config.nested_option_with_default_block).to eq "nested default value from block"

        expect(configurable_module.config_eval(:nested_config, :nested_option_without_default).read).
          to be_nil
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default).read).
          to eq "nested default value"
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default_block).read).
          to eq "nested default value from block"
      end
    end

    describe "deeply nested config vars" do
      it "uses the default values" do
        expect(config.nested_config.double_nested.double_nested_option_without_default).to be_nil
        expect(config.nested_config.double_nested.double_nested_option_with_default).
          to eq "double nested default value"
        expect(config.nested_config.double_nested.double_nested_option_with_default_block).
          to eq "double nested default value from block"
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_without_default).read).
          to be_nil
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default).read).
          to eq "double nested default value"
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default_block).read).
          to eq "double nested default value from block"
      end
    end
  end

  context "when runtime configuration has been set up" do
    let(:option_without_default_override) { "option without default override" }
    let(:option_with_default_override) { "option with default override" }
    let(:option_with_default_block_override) { "option with default block override" }

    let(:nested_option_without_default_override) { "nested option without default override" }
    let(:nested_option_with_default_override) { "nested option with default override" }
    let(:nested_option_with_default_block_override) { "nested option with default block override" }

    let(:double_nested_option_without_default_override) { "double nested option without default override" }
    let(:double_nested_option_with_default_override) { "double nested option with default override" }
    let(:double_nested_option_with_default_block_override) { "double nested option with default block override" }

    let(:option_without_default_override_to_assign) { "option without default override on assign" }
    let(:option_with_default_override_to_assign) { "option with default override on assign" }
    let(:option_with_default_block_override_to_assign) { "option with default block override on assign" }

    let(:nested_option_without_default_override_to_assign) { "nested option without default override on assign" }
    let(:nested_option_with_default_override_to_assign) { "nested option with default override on assign" }
    let(:nested_option_with_default_block_override_to_assign) { "nested option with default block override on assign" }

    before do
      configurable_module.configure do |konfig|
        konfig.option_without_default = option_without_default_override
        konfig.option_with_default = option_with_default_override
        konfig.option_with_default_block = option_with_default_block_override

        konfig.nested_config.nested_option_without_default = nested_option_without_default_override
        konfig.nested_config.nested_option_with_default = nested_option_with_default_override
        konfig.nested_config.nested_option_with_default_block = nested_option_with_default_block_override

        konfig.nested_config.double_nested.double_nested_option_without_default = double_nested_option_without_default_override
        konfig.nested_config.double_nested.double_nested_option_with_default = double_nested_option_with_default_override
        konfig.nested_config.double_nested.double_nested_option_with_default_block = double_nested_option_with_default_block_override

        konfig.assign(
          option_without_default_to_assign: option_without_default_override_to_assign,
          option_with_default_to_assign: option_with_default_override_to_assign,
          option_with_default_block_to_assign: option_with_default_block_override_to_assign,
        )

        konfig.nested_config.assign(
          nested_option_without_default_to_assign: nested_option_without_default_override_to_assign,
          nested_option_with_default_to_assign: nested_option_with_default_override_to_assign,
          nested_option_with_default_block_to_assign: nested_option_with_default_block_override_to_assign,
        )
      end
    end

    describe "root config vars" do
      it "sets the override values" do
        expect(configurable_module.config.option_without_default).to eq option_without_default_override
        expect(configurable_module.config.option_with_default).to eq option_with_default_override
        expect(configurable_module.config.option_with_default_block).to eq option_with_default_block_override
      end

      it "sets the override values with assign" do
        expect(configurable_module.config.option_without_default_to_assign).to eq option_without_default_override_to_assign
        expect(configurable_module.config.option_with_default_to_assign).to eq option_with_default_override_to_assign
        expect(configurable_module.config.option_with_default_block_to_assign).to eq option_with_default_block_override_to_assign
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:option_without_default).read).to eq option_without_default_override
        expect(configurable_module.config_eval(:option_with_default).read).to eq option_with_default_override
        expect(configurable_module.config_eval(:option_with_default_block).read).to eq option_with_default_block_override
      end
    end

    describe "nested config vars" do
      it "sets the override values" do
        expect(configurable_module.config.nested_config.nested_option_without_default).
          to eq nested_option_without_default_override
        expect(configurable_module.config.nested_config.nested_option_with_default).
          to eq nested_option_with_default_override
        expect(configurable_module.config.nested_config.nested_option_with_default_block).
          to eq nested_option_with_default_block_override
      end

      it "sets the override values with assign" do
        expect(configurable_module.config.nested_config.nested_option_without_default_to_assign).
          to eq nested_option_without_default_override_to_assign
        expect(configurable_module.config.nested_config.nested_option_with_default_to_assign).
          to eq nested_option_with_default_override_to_assign
        expect(configurable_module.config.nested_config.nested_option_with_default_block_to_assign).
          to eq nested_option_with_default_block_override_to_assign
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :nested_option_without_default).read).
          to eq nested_option_without_default_override
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default).read).
          to eq nested_option_with_default_override
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default_block).read).
          to eq nested_option_with_default_block_override
      end
    end

    describe "deeply nested config vars" do
      it "sets the override values" do
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_without_default).
          to eq double_nested_option_without_default_override
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default).
          to eq double_nested_option_with_default_override
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default_block).
          to eq double_nested_option_with_default_block_override
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_without_default).read).
          to eq double_nested_option_without_default_override
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default).read).
          to eq double_nested_option_with_default_override
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default_block).read).
          to eq double_nested_option_with_default_block_override
      end
    end
  end
end
