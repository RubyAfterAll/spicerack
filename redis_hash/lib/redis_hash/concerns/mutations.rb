# frozen_string_literal: true

# Mutations allow for the manipulation of data in the Hash.
module RedisHash
  module Mutations
    extend ActiveSupport::Concern

    def compact!
      delete_if { |_, value| value.blank? }
    end

    def invert
      inversion = to_h.invert
      clear
      inversion.each { |key, value| self[key] = value }
    end

    def replace(other_hash)
      clear and merge!(other_hash)
    end
  end
end
