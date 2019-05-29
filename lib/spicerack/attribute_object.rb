# frozen_string_literal: true

require_relative "objects/defaults"
require_relative "objects/attributes"

module Spicerack
  class AttributeObject < Spicerack::RootObject
    include Spicerack::Objects::Defaults
    include Spicerack::Objects::Attributes
  end
end
