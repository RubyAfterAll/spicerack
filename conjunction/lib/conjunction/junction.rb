# frozen_string_literal: true

module Conjunction
  # A **Junction** is an encapsulation of behavior which has been abstracted out of a **Conjunctive**.
  module Junction
    extend ActiveSupport::Concern

    include Conjunction::Conjunctive

    class_methods do
      attr_reader :conjunction_prefix, :conjunction_suffix

      def prototype_name
        output = name
        output.slice!(conjunction_prefix) if conjunction_prefix
        output.chomp!(conjunction_suffix) if conjunction_suffix
        output unless output == name
      end

      def prototype
        prototype_name&.safe_constantize
      end

      def inherited(base)
        base.prefixed_with(conjunction_prefix)
        base.suffixed_with(conjunction_suffix)
      end

      protected

      def prefixed_with(prefix)
        raise TypeError, "prefix must be a string" if prefix.present? && !prefix.is_a?(String)

        @conjunction_prefix = prefix
      end

      def suffixed_with(suffix)
        raise TypeError, "suffix must be a string" if suffix.present? && !suffix.is_a?(String)

        @conjunction_suffix = suffix
      end
    end
  end
end
