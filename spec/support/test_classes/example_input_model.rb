# frozen_string_literal: true

class ExampleInputModel < Spicerack::InputModel
  argument :bottles_of, allow_nil: false

  option :starting_bottles
  option :number_to_take_down, default: 1

  attribute :unused

  validates :number_to_take_down, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
