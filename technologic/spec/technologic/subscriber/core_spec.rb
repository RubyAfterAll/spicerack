# frozen_string_literal: true

RSpec.describe Technologic::Subscriber::Core do
  let(:example_class) { Class.new.include(described_class) }
  let(:severity) { Faker::Internet.domain_word }

  describe ".severity" do
    subject { example_class.severity }

    before { stub_const(class_name, example_class) }

    context "when the class name is modulized" do
      let(:module_name) { Faker::Internet.domain_word.capitalize }
      let(:class_name) { "#{module_name}::#{severity.capitalize}Subscriber" }

      it { is_expected.to eq severity.to_sym }
    end

    context "when the class name is NOT modulized" do
      let(:class_name) { "#{severity.capitalize}Subscriber" }

      it { is_expected.to eq severity.to_sym }
    end
  end

  describe ".call" do
    subject(:call) { example_class.call(name, started, finished, _unique_id, payload) }

    # This is the standard event format emitted by Technologic
    let(:name) { "#{event}.#{class_name}.#{severity}" }
    let(:event) { Faker::Internet.domain_word }
    let(:class_name) { Faker::Internet.domain_word.capitalize }
    let(:started) { double }
    let(:finished) { double }
    let(:payload) { double }
    let(:_unique_id) { double }
    let(:expected_event_name) { "#{event}.#{class_name}" }
    let(:event_instance) { instance_double(Technologic::Event) }

    before do
      allow(example_class).to receive(:trigger)
      allow(example_class).to receive(:severity).and_return(severity)
      allow(Technologic::Event).
        to receive(:new).
        with(expected_event_name, started, finished, payload).
        and_return(event_instance)
    end

    it "triggers the event" do
      call
      expect(example_class).to have_received(:trigger).with(event_instance)
    end
  end
end
