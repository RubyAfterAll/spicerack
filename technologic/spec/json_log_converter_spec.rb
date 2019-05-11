# frozen_string_literal: true

RSpec.describe JsonLogConverter do
  let(:severity) { %w[DEBUG INFO WARN ERROR FATAL].sample }
  let(:timestamp) { Time.now }
  let(:progname) { nil }
  let(:msg) { Faker::Lorem.sentence }
  let(:example_class) do
    Class.new do
      def self.current_tags
        []
      end
    end
  end

  before { example_class.extend(described_class) }

  describe ".convert_rails_logger" do
    let(:formatter) { double }
    let(:logger) { double(formatter: formatter) }
    let(:rails) { double(logger: logger) }

    before do
      stub_const("Rails", rails)
      allow(formatter).to receive(:extend)
    end

    shared_examples_for "the Rails.logger.formatter is extended" do
      subject { formatter }

      before { convert_rails_logger }

      it { is_expected.to have_received(:extend).with(described_class) }
    end

    context "when called with a block" do
      subject(:convert_rails_logger) { described_class.convert_rails_logger(&block) }

      let(:block) do
        ->(severity, timestamp, message) { { test: true, severity: severity, timestamp: timestamp, message: message } }
      end

      it_behaves_like "the Rails.logger.formatter is extended"

      it "defines the method with the block" do
        allow(described_class).to receive(:define_method) do |method_name, &method_block|
          expect(method_name).to eq :log_payload_for
          expect(method_block).to eq block
        end

        convert_rails_logger

        expect(described_class).to have_received(:define_method)
      end
    end

    context "when NOT called with a block" do
      subject(:convert_rails_logger) { described_class.convert_rails_logger }

      it_behaves_like "the Rails.logger.formatter is extended"
    end
  end

  describe "#call" do
    subject { example_class.call(severity, timestamp, progname, msg) }

    let(:example_payload) do
      { test: true, severity: severity, timestamp: timestamp, message: msg }
    end

    before { allow(example_class).to receive(:log_payload_for).and_return(example_payload) }

    it { is_expected.to eq "#{example_payload.to_json}\n" }
  end

  describe "#default_json_payload" do
    subject { example_class.default_json_payload(severity, timestamp, msg) }

    let(:core_payload) do
      { severity: severity, timestamp: timestamp }
    end
    let(:base_payload) { core_payload.merge(message: msg) }
    let(:expected_payload) { base_payload }

    context "with current_tags" do
      let(:current_tags) { Faker::Lorem.words }
      let(:expected_payload) { base_payload.merge(tags: current_tags) }

      before { allow(example_class).to receive(:current_tags).and_return(current_tags) }

      it { is_expected.to eq expected_payload }
    end

    context "without current_tags" do
      it { is_expected.to eq expected_payload }
    end

    context "when msg is an array" do
      let(:msg) { Faker::Lorem.words(2) }

      it { is_expected.to eq expected_payload }
    end

    context "when msg is a hash" do
      let(:msg) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

      let(:expected_payload) { core_payload.merge(msg) }

      it { is_expected.to eq expected_payload }
    end
  end

  describe "#split_event_key_for_payload" do
    subject { example_class.split_event_key_for_payload(payload) }

    let(:payload) { base_payload.merge(event: event) }
    let(:base_payload) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }
    let(:expected_payload) { payload }

    context "with no event key" do
      let(:payload) { base_payload }

      it { is_expected.to eq base_payload }
    end

    context "with a nil event key" do
      let(:event) { nil }

      it { is_expected.to eq expected_payload }
    end

    context "with an event key with no period" do
      let(:event) { Faker::Lorem.word }

      it { is_expected.to eq expected_payload }
    end

    context "with an event key with multiple periods" do
      let(:event) { Faker::Lorem.words(3).join(".") }

      it { is_expected.to eq expected_payload }
    end

    context "with an event key with multiple periods" do
      let(:expected_event) { Faker::Lorem.unique.word }
      let(:expected_class) { Faker::Lorem.unique.word }

      let(:event) { "#{expected_event}.#{expected_class}" }

      let(:expected_payload) { base_payload.merge(event: expected_event, class: expected_class) }

      it { is_expected.to eq expected_payload }
    end
  end

  describe "#log_payload_for" do
    subject { example_class.log_payload_for(severity, timestamp, msg) }

    let(:example_payload) do
      { test: true, severity: severity, timestamp: timestamp, message: msg }
    end

    before do
      allow(example_class).to receive(:default_json_payload).with(severity, timestamp, msg).and_return(example_payload)
    end

    it { is_expected.to eq example_payload }
  end
end
