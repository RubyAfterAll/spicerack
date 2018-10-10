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
    shared_examples_for "expected data is returned" do
      subject { event.data }

      let(:expected_base_data) { payload.merge(event: name) }

      it { is_expected.to eq expected_data }
    end

    context "when rounded duration is 0" do
      let(:finished) { started + (rand * 0.5) }

      it_behaves_like "expected data is returned" do
        let(:expected_data) { expected_base_data }
      end
    end

    context "when rounded duration is greater than 0" do
      it_behaves_like "expected data is returned" do
        let(:expected_data) { expected_base_data.merge(duration: finished - started) }
      end
    end
  end
end
