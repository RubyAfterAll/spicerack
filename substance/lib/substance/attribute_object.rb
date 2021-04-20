# frozen_string_literal: true

require_relative "objects/defaults"
require_relative "objects/attributes"

module Substance
  class AttributeObject < Substance::RootObject
    include Substance::Objects::Defaults
    include Substance::Objects::Attributes
  end
end
