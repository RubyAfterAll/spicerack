# frozen_string_literal: true

class ExampleConfigurable
  include Spicerack::Configurable

  option :no_default
  option :has_default, "A default value"
end
