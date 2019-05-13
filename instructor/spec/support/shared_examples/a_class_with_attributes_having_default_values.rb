# frozen_string_literal: true

RSpec.shared_examples_for "a class with attributes having default values" do
  before do
    key_values.each { |key, value| instance.public_send("#{key}=".to_sym, value) }
  end

  context "when all values are defined" do
    let(:key_values) do
      { test_option1: :test_value1, test_option2: :test_value2 }
    end

    it "uses provided data" do
      key_values.each { |key, value| expect(instance.public_send(key)).to eq value }
    end
  end

  context "when one value is omitted" do
    let(:key_values) do
      { test_option1: :test_value1 }
    end

    it "uses provided and default data" do
      expect(instance.test_option1).to eq key_values[:test_option1]
      expect(instance.test_option2).to eq :default_value2
    end
  end

  context "when all values are omitted" do
    let(:key_values) do
      {}
    end

    it "uses default data" do
      expect(instance.test_option1).to eq :default_value1
      expect(instance.test_option2).to eq :default_value2
    end
  end
end
