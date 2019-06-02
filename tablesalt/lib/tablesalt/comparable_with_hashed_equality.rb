# frozen_string_literal: true

# Include this module on any class that needs to be both Comparable
# and also use hash for its equality methods. Because Comparable defines
# == using <=>, we need to re-define == and eql? to use hash.
module Tablesalt
  module ComparableWithHashedEquality
    extend ActiveSupport::Concern
    include Comparable
    include Tablesalt::HashedEquality
  end
end
