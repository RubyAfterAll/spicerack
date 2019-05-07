# frozen_string_literal: true

RSpec.describe Callforth::Setup do
  let(:application) { double(config: double(callforth: config)) } # rubocop:disable RSpec/VerifiedDoubles
  let(:config) { instance_double(Callforth::ConfigOptions) }

  describe ".for" do
    subject(:for_application) { described_class.for(application) }

    before do
      allow(described_class).to receive(:setup_secret_key)
    end

    it "calls constituent methods with the given config" do
      for_application

      expect(described_class).to have_received(:setup_secret_key).with(config)
    end
  end

  describe ".clear" do
    subject(:clear) { described_class.clear }

    before do
      allow(described_class).to receive(:clear_secret_key)
    end

    it "calls constituent methods" do
      clear

      expect(described_class).to have_received(:clear_secret_key)
    end
  end

  describe ".setup_secret_key" do
    subject(:setup_secret_key) { described_class.__send__(:setup_secret_key, config) }

    before { allow(config).to receive(:secret_key).and_return(secret_key) }

    shared_examples_for "the secret key is set" do
      let(:expected_secret_key) { secret_key }

      it "sets the secret key" do
        expect { setup_secret_key }.to change { Callforth.secret_key }.to(expected_secret_key)
      end
    end

    context "with a block" do
      let(:secret_key) do
        -> { :key_from_block }
      end

      it_behaves_like "the secret key is set" do
        let(:expected_secret_key) { :key_from_block }
      end
    end

    context "with a static value" do
      let(:secret_key) { SecureRandom.hex }

      it_behaves_like "the secret key is set"
    end

    context "with a nil" do
      let(:secret_key) { nil }

      it_behaves_like "the secret key is set"
    end
  end

  describe ".clear_secret_key" do
    subject(:clear_secret_key) { described_class.__send__(:clear_secret_key) }

    let(:secret_key) { SecureRandom.hex }

    before { Callforth.secret_key = secret_key }

    it "clears the secret key" do
      expect { clear_secret_key }.to change { Callforth.secret_key }.from(secret_key).to(nil)
    end
  end
end
