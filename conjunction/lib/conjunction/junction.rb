# frozen_string_literal: true

module Conjunction
  # A **Junction** is an encapsulation of behavior which has been abstracted out of a **Conjunctive**.
  module Junction
    extend ActiveSupport::Concern

    include Conjunction::Conjunctive
    include Conjunction::NamingConvention

    included do
      delegate :conjunction_for!, :conjunction_for, :conjunction_name_for, to: :class
    end

    class_methods do
      def junction_key
        [ conjunction_prefix, conjunction_suffix ].compact.join.underscore.to_sym if conjunctive?
      end

      def prototype_name
        output = name
        output.slice!(conjunction_prefix) if conjunction_prefix?
        output.chomp!(conjunction_suffix) if conjunction_suffix?
        output unless output == name
      end

      def conjunction_for!(other_prototype)
        conjunction_for(other_prototype) or raise DisjointedError, "#{other_prototype} disjointed with #{name}"
      end

      def conjunction_for(other_prototype)
        conjunction_name_for(other_prototype)&.safe_constantize
      end

      private

      def conjunction_name_for(other_prototype)
        raise TypeError, "invalid prototype #{other_prototype}" unless other_prototype.respond_to?(:prototype_name)

        [ conjunction_prefix, other_prototype.prototype_name, conjunction_suffix ].compact.join if conjunctive?
      end
    end
  end
end
