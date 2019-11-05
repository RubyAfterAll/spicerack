# frozen_string_literal: true

module Conjunction
  # **Conjunctives** are **Prototypes** that can be `conjugated` with a **Junction** into a specific **Conjunction**.
  module Conjunctive
    extend ActiveSupport::Concern

    include Conjunction::Prototype

    included do
      class_attribute :explicit_conjunctions, instance_writer: false, default: {}

      delegate :conjugate, :conjugate!, to: :class
    end

    class_methods do
      def conjugate(junction)
        conjunction_for(junction, :conjunction_for)
      end

      def conjugate!(junction)
        conjunction_for(junction, :conjunction_for!)
      end

      def inherited(base)
        base.explicit_conjunctions = {}
        super
      end

      private

      def conjunction_for(junction, method_name)
        junction_key = junction.try(:junction_key)
        return explicit_conjunctions[junction_key] if junction_key.present? && explicit_conjunctions.key?(junction_key)

        junction.try(method_name, prototype_name)
      end

      def conjoins(junction)
        raise TypeError, "#{junction} is not a valid junction" unless junction.respond_to?(:junction_key)

        explicit_conjunctions[junction.junction_key] = junction
      end
    end
  end
end
