# frozen_string_literal: true

# Callbacks provide an extensible mechanism for hooking into a RedisHash.
module Tablesalt
  module RedisHash
    module Callbacks
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks
        define_callbacks :initialize
      end
    end
  end
end
