# frozen_string_literal: true

RSpec.describe Technologic::Event do
  subject(:event) { described_class.new(name, started, finished, payload) }

  let(:name) { Faker::Lorem.word }
  let(:started) { rand(5..10) }
  let(:finished) { rand(15..20) }
  let(:payload) { Hash[*Faker::Lorem.words(2 * rand(1..2))] }

  it { is_expected.to include_module ShortCircuIt }

  describe "#initialize" do
    it "initializes values" do
      expect(event.name).to eq name
      expect(event.duration).to eq finished - started
    end
  end

  describe "#data" do
    before { Technologic::ConfigOptions.log_duration_in_ms = log_duration_in_ms }

    shared_examples_for "expected data is returned" do
      subject { event.data }

      let(:expected_base_data) { payload.merge(event: name, duration: duration) }

      it { is_expected.to eq expected_data }
    end

    context "when log_duration_in_ms is false" do
      let(:log_duration_in_ms) { false }
      let(:duration) { finished - started }

      context "when rounded duration is under threshold" do
        let(:finished) { started + rand(0...0.00004) }

        it_behaves_like "expected data is returned" do
          let(:expected_data) { expected_base_data.except(:duration) }
        end
      end

      context "when rounded duration is above threshold" do
        let(:finished) { started + rand(0.00004...0.00009) }

        it_behaves_like "expected data is returned" do
          let(:expected_data) { expected_base_data }
        end
      end
    end

    context "when log_duration_in_ms is true" do
      let(:log_duration_in_ms) { true }
      let(:duration) { (finished - started) * 1000 }

      context "when rounded duration is under threshold" do
        let(:finished) { started + rand(0...0.00004) }

        it_behaves_like "expected data is returned" do
          let(:expected_data) { expected_base_data.except(:duration) }
        end
      end

      context "when rounded duration is above threshold" do
        let(:finished) { started + rand(0.00004...0.00009) }

        it_behaves_like "expected data is returned" do
          let(:expected_data) { expected_base_data }
        end
      end
    end
  end
end
