# frozen_string_literal: true

require_relative "instructor/callbacks"
require_relative "instructor/attributes"
require_relative "instructor/arguments"
require_relative "instructor/options"
require_relative "instructor/core"

module Spicerack
  class InstructorBase
    include ShortCircuIt
    include Technologic
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    include Tablesalt::StringableObject
    include Tablesalt::Dsl::Defaults
    include Instructor::Callbacks
    include Instructor::Attributes
    include Instructor::Arguments
    include Instructor::Options
    include Instructor::Core
  end
end
