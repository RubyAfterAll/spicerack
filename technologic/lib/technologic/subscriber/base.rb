# frozen_string_literal: true

require_relative "core"
require_relative "event_handling"

module Technologic
  module Subscriber
    class Base
      include Core
      include EventHandling
    end
  end
end
