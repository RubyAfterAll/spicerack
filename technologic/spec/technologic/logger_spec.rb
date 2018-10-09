# frozen_string_literal: true

RSpec.describe Technologic::Logger do
  describe ".log" do
    subject { described_class.log(severity, event) }

    let(:severity) { Faker::Internet.domain_word.to_sym }
    let(:event) { instance_double(Technologic::Event) }
    let(:event_data) { Hash[Faker::Lorem.words(2 * rand(2..4))] }
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

      # Store the results of the block so they can be asserted against later
      allow(Rails.logger).to(receive(severity).with(no_args)) { |&block| @result = block.yield }
    end

    it "formats and logs the data" do
      data_values.each_with_index do |datum, index|
        allow(described_class).to receive(:format_value_for_log).with(datum).and_return("formatted_for_idx#{index}")
      end
      expect(@result).to eq expected_log_data # rubocop:disable RSpec/InstanceVariable
    end

    # Rails.logger.public_send(severity) do
    #   event.data.transform_values { |value| format_value_for_log(value) }
    # end
  end

  describe ".format_value_for_log" do
    it "needs specs"
  end
end
