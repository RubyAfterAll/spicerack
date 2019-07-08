# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::ConfigObject do
  subject(:config) { config_object_class.instance }

  let(:config_object_class) { Class.new(described_class) }

  it { is_expected.to inherit_from Spicerack::InputObject }
  it { is_expected.to include_module Singleton }

  describe ".nested" do
    let(:namespace) { Faker::Lorem.words.join("_") }
    let(:nested_option) { Faker::Lorem.word }
    let(:nested_default_value) { Faker::ChuckNorris.fact }

    before do
      config_object_class.instance_exec(self) do |spec_context|
        nested spec_context.namespace do
          option spec_context.nested_option, default: spec_context.nested_default_value
        end
      end
    end

    it "defines a nested config object" do
      expect(config.public_send(namespace)).to inherit_from described_class
      expect(config.public_send(namespace).public_send(nested_option)).to eq nested_default_value
    end
  end
end
