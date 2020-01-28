# frozen_string_literal: true

require "directive"

module Spicerack
  include ActiveSupport::Deprecation::DeprecatedConstantAccessor

  # Deprecation support for Directive cutover.
  Configurable = Directive

  deprecate_constant("Spicerack::Configurable", Directive)
end
