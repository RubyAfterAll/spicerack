# frozen_string_literal: true

# RSpec matcher to test options of a Configurable class
#
#     class ExampleConfiguration
#       include Spicerack::Configurable
#
#       option :foo
#       option :bar, default: :baz
#     end
#
#     RSpec.describe ExampleConfiguration, type: :configuration do
#       subject { described_class.new }\
#
#       it { is_expected.to define_config_option :foo }
#       it { is_expected.to define_config_option :bar, default: :baz }
#     end

RSpec::Matchers.define :define_config_option do |option, default: nil|
  match do |obj|
    expect(obj).to respond_to :config
    expect(obj.config.instance_variable_get(:@config)).to be_present
    expect(obj.config.instance_variable_get(:@config)).to define_option option, default: default
  end
end
