# frozen_string_literal: true

module Spicerack
  class RootObject
    include ActiveSupport::Callbacks
    include ShortCircuIt
    include Technologic
    include Tablesalt::StringableObject
  end
end
