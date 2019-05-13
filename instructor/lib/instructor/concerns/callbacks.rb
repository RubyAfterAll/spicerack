# frozen_string_literal: true

# Callbacks provide an extensible mechanism for hooking into an Instructor.
module Instructor
  module Callbacks
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Callbacks
      define_callbacks :initialize
    end
  end
end
