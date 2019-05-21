# frozen_string_literal: true

require_relative "concerns/callbacks"
require_relative "concerns/defaults"
require_relative "concerns/attributes"
require_relative "concerns/arguments"
require_relative "concerns/options"
require_relative "concerns/core"

module Instructor
  class Base
    include ShortCircuIt
    include Technologic
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
    include Tablesalt::StringableObject
    include Instructor::Callbacks
    include Instructor::Defaults
    include Instructor::Attributes
    include Instructor::Arguments
    include Instructor::Options
    include Instructor::Core
  end
end
