# frozen_string_literal: true

require_relative "../support/test_classes/bottles_on_the_wall"

RSpec.describe BottlesOnTheWall, type: :instructor do
  subject(:instructor) { described_class.new(bottles_of: :test_fluid) }

  it { is_expected.to define_argument :bottles_of, allow_nil: false }
  it { is_expected.to define_option :starting_bottles }
  it { is_expected.to define_option :number_to_take_down, default: 1 }
  it { is_expected.to define_attribute :unused }
  it { is_expected.to validate_numericality_of(:number_to_take_down).is_greater_than_or_equal_to(0).only_integer }

  describe "#to_s" do
    subject { instructor.to_s }

    it { is_expected.to eq "#<BottlesOnTheWall bottles_of=test_fluid starting_bottles= number_to_take_down=1 unused=>" }
  end
end
