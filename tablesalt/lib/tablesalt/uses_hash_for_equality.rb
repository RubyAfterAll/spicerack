# frozen_string_literal: true

require "active_support/concern"

module Tablesalt
  module UsesHashForEquality
    extend ActiveSupport::Concern

    def ==(other)
      hash == other.hash
    end
    alias_method :eql?, :==
  end
end
