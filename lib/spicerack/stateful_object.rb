# frozen_string_literal: true

require_relative "objects/output"

module Spicerack
  class StatefulObject < InputModel
    include Objects::Output
  end
end
