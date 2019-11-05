# frozen_string_literal: true

module Conjunction
  # A **Junction** is an encapsulation of behavior which has been abstracted out of a **Conjunctive**.
  module Junction
    extend ActiveSupport::Concern

    include Conjunction::Conjunctive
    include Conjunction::NamingConvention

    class_methods do
      def junction_key
        [ conjunction_prefix, conjunction_suffix ].compact.join.underscore.to_sym
      end

      def prototype_name
        output = name
        output.slice!(conjunction_prefix) if conjunction_prefix
        output.chomp!(conjunction_suffix) if conjunction_suffix
        output unless output == name
      end
    end
  end
end
