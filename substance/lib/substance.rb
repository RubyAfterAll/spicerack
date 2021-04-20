# frozen_string_literal: true

require_relative "substance/version"

require_relative "substance/root_object"
require_relative "substance/attribute_object"
require_relative "substance/input_object"
require_relative "substance/input_model"
require_relative "substance/output_object"

module Substance
  class Error < StandardError; end
  class NotValidatedError < Error; end
end
