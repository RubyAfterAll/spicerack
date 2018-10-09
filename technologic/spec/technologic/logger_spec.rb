# frozen_string_literal: true

RSpec.describe Technologic::Logger do
  describe ".log" do
    subject(:log) { described_class.log(severity, event) }

    let(:severity) { Faker::Internet.domain_word.to_sym }
    let(:event) { instance_double(Technologic::Event, data: event_data) }
    let(:event_data) { Hash[*Faker::Lorem.words(2 * rand(2..4))] }
    let(:data_keys) { event_data.keys }
    let(:data_values) { event_data.values }
    let(:expected_log_data) do
      data_values.each_with_index.each_with_object({}) do |(_datum, index), hash|
        hash[data_keys[index]] = "formatted_for_idx#{index}"
      end
    end

    before do
      data_values.each_with_index do |datum, index|
        allow(described_class).to receive(:format_value_for_log).with(datum).and_return("formatted_for_idx#{index}")
      end
    end

    context "when rails is not defined" do
      it "does not error" do
        expect { log }.not_to raise_error
      end
    end

    context "when rails is defined" do
      let(:rails) { double }
      let(:logger) { double }

      before do
        stub_const("Rails", rails)
        allow(rails).to receive(:logger).and_return(logger)

        data_values.each_with_index do |datum, index|
          allow(described_class).to receive(:format_value_for_log).with(datum).and_return("formatted_for_idx#{index}")
        end

        @yield = nil
        allow(logger).to receive(severity).with(no_args) { |&block| @yield = block.yield }
      end

      it "logs formatted data" do
        expect { log }.to change { @yield }.from(nil).to(expected_log_data) # rubocop:disable RSpec/InstanceVariable
      end
    end
  end

  describe ".format_value_for_log" do
    it "needs specs"
  end
end
