# frozen_string_literal: true

require_relative "ascriptor/defaults"
require_relative "ascriptor/attributes"

module Spicerack
  class AscriptorBase < Spicerack::RootObject
    include Spicerack::Ascriptor::Defaults
    include Spicerack::Ascriptor::Attributes
  end
end
