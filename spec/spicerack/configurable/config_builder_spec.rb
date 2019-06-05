# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::ConfigBuilder do
  subject(:builder) { described_class.new }

  let(:all_options) { Faker::Lorem.words(4).map(&:to_sym) }
  let(:options_with_defaults) { all_options.sample(2) }
  let(:options_without_defaults) { all_options - options_with_defaults }
  let(:default_values) do
    options_with_defaults.each_with_object({}) { |opt, hash| hash[opt] = Faker::Hipster.word }
  end

  before do
    options_without_defaults.each { |opt| builder.option opt }
    default_values.each { |opt, default| builder.option opt, default: default }
  end

  describe "#reader" do
    subject(:reader) { builder.reader }

    it { is_expected.to be_a Spicerack::Configurable::Reader }
    it "returns all config values" do
      options_without_defaults.each do |opt|
        expect(reader.public_send(opt)).to eq nil
      end

      default_values.each do |opt, value|
        expect(reader.public_send(opt)).to eq value
      end
    end
  end

  describe "#configure" do
    it "yields the input object" do
      builder.configure do |config|
        expect(config).to be_a Spicerack::InputObject

        all_options.each do |opt|
          expect(config).to define_option opt, default: default_values[opt]
        end
      end
    end
  end

  describe "#option" do
    let(:additional_option) { Faker::Superhero.name.parameterize.underscore.to_sym }
    let(:additional_default_value) { Faker::Lorem.sentence }

    before { builder.option(additional_option, default: additional_default_value) }

    it "adds the additional option" do
      builder.configure do |config|
        expect(config).to define_option(additional_option, default: additional_default_value)
      end
    end
  end
end
