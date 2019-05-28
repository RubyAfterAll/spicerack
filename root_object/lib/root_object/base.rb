# frozen_string_literal: true

module RootObject
  class Base
    include ActiveSupport::Callbacks
    include ShortCircuIt
    include Technologic
    include Tablesalt::StringableObject
  end
end
