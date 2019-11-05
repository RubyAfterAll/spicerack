# frozen_string_literal: true

module Conjunction
  # A **Prototype** is a uniquely named Object with behavior which has been abstracted out into **Junction** classes.
  module Prototype
    extend ActiveSupport::Concern

    included do
      delegate :prototype_name, to: :class
    end

    def prototype
      self
    end

    class_methods do
      def prototype_name
        try(:model_name)&.name || name
      end
    end
  end
end
