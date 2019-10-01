# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/module/delegation"

module Tablesalt
  module Isolation
    extend ActiveSupport::Concern

    included do
      delegate :isolate, to: :class
    end

    module ClassMethods
      # Dupes an item if possible. Classes/modules can have unpredictable effects when duped, so they are not.
      def isolate(obj)
        return obj if obj.is_a?(Module)

        obj.clone
      end
    end
  end
end
