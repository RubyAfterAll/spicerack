# frozen_string_literal: true

module Conjunction
  # A **NamingConvention** defines the name formatting of a given **Junction**.
  module NamingConvention
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :conjunction_prefix, :conjunction_suffix

      def inherited(base)
        base.prefixed_with(conjunction_prefix)
        base.suffixed_with(conjunction_suffix)
        super
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
