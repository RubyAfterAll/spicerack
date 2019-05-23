# frozen_string_literal: true

module Spicerack
  class RedisModel < RedisHash::Base
    include Spicerack::HashModel

    alias_method :data, :itself

    class << self
      def field(name, *)
        allow_keys(name)
        super
      end
    end
  end
end
