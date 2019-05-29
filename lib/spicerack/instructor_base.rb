# frozen_string_literal: true

module Spicerack
  class InstructorBase < Spicerack::InputObject
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
  end
end
