# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::ConfigObject do
  subject(:config) { config_object_class.instance }

  let(:config_object_class) { Class.new(described_class) }

  it { is_expected.to inherit_from Spicerack::InputObject }
  it { is_expected.to include_module Singleton }
  it { is_expected.to include_module ActiveModel::AttributeAssignment }

  # it { is_expected.to alias_method :assign, :assign_attributes }

  describe ".option" do
    let(:name) { Faker::Lorem.word }
    let(:default_value) { Faker::Hipster.sentence }
    let(:config_object_class) do
      Class.new(described_class).tap do |klass|
        klass.instance_exec(self) do |spec_context|
          option spec_context.name, default: spec_context.default_value
        end
      end
    end

    it { is_expected.to define_option name, default: default_value }

    context "when a reserved word is used" do
      let(:name) { described_class::RESERVED_WORDS.sample.to_s }

      it "raises an ArgumentError" do
        expect { config_object_class }.
          to raise_error ArgumentError, "\"config_eval\" is reserved and cannot be used at a config option"
      end
    end
  end

  describe ".nested" do
    let(:namespace) { Faker::Lorem.words.join("_") }
    let(:nested_option) { Faker::Lorem.word }
    let(:nested_default_value) { Faker::ChuckNorris.fact }

    let(:nested_config_setup) do
      lambda do
        config_object_class.instance_exec(self) do |spec_context|
          nested spec_context.namespace do
            option spec_context.nested_option, default: spec_context.nested_default_value
          end
        end
      end
    end

    context "when an allowed word is used" do
      before { nested_config_setup.call }

      it "defines a nested config object" do
        expect(config.public_send(namespace)).to inherit_from described_class
        expect(config.public_send(namespace).public_send(nested_option)).to isolate nested_default_value
      end

      context "when a nested config is used twice" do
        it "raises an ArgumentError" do
          expect(nested_config_setup).
            to raise_error ArgumentError, "#{namespace.inspect} is already in use"
        end
      end
    end

    context "when a reserved word is used" do
      let(:namespace) { described_class::RESERVED_WORDS.sample.to_s }

      it "raises an ArgumentError" do
        expect(nested_config_setup).
          to raise_error ArgumentError, "\"config_eval\" is reserved and cannot be used at a config option"
      end
    end
  end
end
