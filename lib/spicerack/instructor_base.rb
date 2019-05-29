# frozen_string_literal: true

require_relative "instructor/attributes"
require_relative "instructor/arguments"
require_relative "instructor/options"
require_relative "instructor/core"

module Spicerack
  class InstructorBase < Spicerack::AscriptorBase
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    include Instructor::Core
    include Instructor::Attributes
    include Instructor::Arguments
    include Instructor::Options
  end
end
