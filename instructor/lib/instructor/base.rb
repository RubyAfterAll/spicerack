# frozen_string_literal: true

module Instructor
  class Base
    include ShortCircuIt
    include Technologic
    include ActiveModel::Model
    include ActiveModel::Validations::Callbacks
  end
end
