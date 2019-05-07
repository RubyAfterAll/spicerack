# frozen_string_literal: true

RSpec.describe Callforth::ConfigOptions do
  shared_examples_for "a config option" do |option|
    subject { test_class.public_send(option) }

    let(:test_class) { described_class.dup }
    let(:new_value) { double }
    let(:default_value) { true }

    it "has a default value which can be changed" do
      expect { test_class.public_send("#{option}=", new_value) }.
        to change { test_class.public_send(option) }.
        from(default_value).
        to(new_value)
    end
  end

  describe ".enabled" do
    it_behaves_like "a config option", :enabled
  end

  describe ".secret_key" do
    it_behaves_like "a config option", :secret_key do
      let(:default_value) { instance_of(Proc) }
    end

    context "when called" do
      subject { described_class.secret_key.call }

      let(:rails) { double(application: double(credentials: double(secret_key_base: secret_key_base))) }
      let(:secret_key_base) { SecureRandom.hex }

      before { stub_const("Rails", rails) }

      it { is_expected.to eq secret_key_base }
    end
  end
end
