# frozen_string_literal: true

RSpec.describe Technologic::Setup do
  let(:application) { double(config: double(technologic: config)) } # rubocop:disable RSpec/VerifiedDoubles
  let(:config) { instance_double(Technologic::ConfigOptions) }

  describe ".for" do
    subject(:for_application) { described_class.for(application) }

    before do
      allow(described_class).to receive(:setup_subscribers)
      allow(described_class).to receive(:setup_loggers)
    end

    it "calls constituent methods with the given config" do
      for_application

      expect(described_class).to have_received(:setup_subscribers).with(config)
      expect(described_class).to have_received(:setup_loggers).with(config)
    end
  end

  describe ".setup_subscribers" do
    subject(:setup_subscribers) { described_class.__send__(:setup_subscribers, config) }

    let(:subscribe_to_fatal) { false }
    let(:subscribe_to_error) { false }
    let(:subscribe_to_warn) { false }
    let(:subscribe_to_info) { false }
    let(:subscribe_to_debug) { false }

    before do
      allow(ActiveSupport::Notifications).to receive(:subscribe).and_call_original

      allow(config).to receive(:subscribe_to_fatal)
      allow(config).to receive(:subscribe_to_error)
      allow(config).to receive(:subscribe_to_warn)
      allow(config).to receive(:subscribe_to_info)
      allow(config).to receive(:subscribe_to_debug)
    end

    shared_examples_for "a notification subscriber" do |severity|
      before do
        allow(config).to receive(config_key).and_return(config_value)
        setup_subscribers
      end

      let(:config_key) { "subscribe_to_#{severity}".to_sym }
      let(:severity_regex) { %r{\.#{severity}$} }
      let(:subscriber_class) { "Technologic::#{severity.to_s.capitalize}Subscriber".constantize }

      context "when false" do
        let(:config_value) { false }

        it "does not subscribe" do
          expect(ActiveSupport::Notifications).not_to have_received(:subscribe).with(severity_regex, subscriber_class)
        end
      end

      context "when true" do
        let(:config_value) { true }

        it "subscribes" do
          expect(ActiveSupport::Notifications).to have_received(:subscribe).with(severity_regex, subscriber_class)
        end
      end
    end

    it_behaves_like "a notification subscriber", :fatal
    it_behaves_like "a notification subscriber", :error
    it_behaves_like "a notification subscriber", :warn
    it_behaves_like "a notification subscriber", :info
    it_behaves_like "a notification subscriber", :debug
  end

  describe ".setup_loggers" do
    subject(:setup_loggers) { described_class.__send__(:setup_loggers, config) }

    let(:log_fatal_events) { false }
    let(:log_fatal_events) { false }
    let(:log_fatal_events) { false }
    let(:log_fatal_events) { false }
    let(:log_fatal_events) { false }

    before do
      allow(config).to receive(:log_fatal_events)
      allow(config).to receive(:log_error_events)
      allow(config).to receive(:log_warn_events)
      allow(config).to receive(:log_info_events)
      allow(config).to receive(:log_debug_events)
    end

    shared_examples_for "a subscription event listener" do |severity|
      before do
        allow(config).to receive(config_key).and_return(config_value)
        allow(subscriber_class).to receive(:on_event).with(no_args) { |&block| @block = block }

        setup_loggers
      end

      let(:config_key) { "log_#{severity}_events".to_sym }
      let(:subscriber_class) { "Technologic::#{severity.to_s.capitalize}Subscriber".constantize }

      context "when false" do
        let(:config_value) { false }

        it "does not register handler" do
          expect(subscriber_class).not_to have_received(:on_event)
        end
      end

      context "when true" do
        let(:config_value) { true }
        let(:event) { instance_double(Technologic::Event) }

        before { allow(Technologic::Logger).to receive(:log) }

        it "registers correct handler" do
          expect(subscriber_class).to have_received(:on_event)

          @block.call(event) # rubocop:disable RSpec/InstanceVariable

          expect(Technologic::Logger).to have_received(:log).with(severity, event)
        end
      end
    end

    it_behaves_like "a subscription event listener", :fatal
    it_behaves_like "a subscription event listener", :error
    it_behaves_like "a subscription event listener", :warn
    it_behaves_like "a subscription event listener", :info
    it_behaves_like "a subscription event listener", :debug
  end
end
