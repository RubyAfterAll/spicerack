# frozen_string_literal: true

require_relative "ascriptor/defaults"

module Spicerack
  class AscriptorBase < Spicerack::RootObject
    include Spicerack::Ascriptor::Defaults
  end
end
