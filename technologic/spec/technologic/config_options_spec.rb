# frozen_string_literal: true

RSpec.describe Technologic::ConfigOptions do
  shared_examples_for "a config option" do |option, default_value = true|
    subject { described_class.public_send(option) }

    let(:new_value) { double }

    it "has a default value which can be changed" do
      expect { described_class.public_send("#{option}=", new_value) }.
        to change { described_class.public_send(option) }.
        from(default_value).
        to(new_value)
    end
  end

  describe ".enabled" do
    it_behaves_like "a config option", :enabled
  end

  describe ".subscribe_to_fatal" do
    it_behaves_like "a config option", :subscribe_to_fatal
  end

  describe ".subscribe_to_error" do
    it_behaves_like "a config option", :subscribe_to_error
  end

  describe ".subscribe_to_warn" do
    it_behaves_like "a config option", :subscribe_to_warn
  end

  describe ".subscribe_to_info" do
    it_behaves_like "a config option", :subscribe_to_info
  end

  describe ".subscribe_to_debug" do
    it_behaves_like "a config option", :subscribe_to_debug
  end

  describe ".log_fatal_events" do
    it_behaves_like "a config option", :log_fatal_events
  end

  describe ".log_error_events" do
    it_behaves_like "a config option", :log_error_events
  end

  describe ".log_warn_events" do
    it_behaves_like "a config option", :log_warn_events
  end

  describe ".log_info_events" do
    it_behaves_like "a config option", :log_info_events
  end

  describe ".log_debug_events" do
    it_behaves_like "a config option", :log_debug_events
  end
end
