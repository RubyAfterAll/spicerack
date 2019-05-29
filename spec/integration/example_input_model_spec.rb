# frozen_string_literal: true

RSpec.describe ExampleInputModel, type: :input_model do
  subject(:input_model) { described_class.new(bottles_of: :fluid) }

  it { is_expected.to define_argument :bottles_of, allow_nil: false }
  it { is_expected.to define_option :starting_bottles }
  it { is_expected.to define_option :number_to_take_down, default: 1 }
  it { is_expected.to define_attribute :unused }
  it { is_expected.to validate_numericality_of(:number_to_take_down).is_greater_than_or_equal_to(0).only_integer }

  describe "#to_s" do
    subject { input_model.to_s }

    it { is_expected.to eq "#<ExampleInputModel bottles_of=fluid starting_bottles= number_to_take_down=1 unused=>" }
  end
end
