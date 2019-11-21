# frozen_string_literal: true

require "active_support"
require "conjunction/version"

require "conjunction/nexus"

require "conjunction/prototype"
require "conjunction/conjunctive"
require "conjunction/naming_convention"
require "conjunction/junction"

module Conjunction
  class Error < StandardError; end
  class DisjointedError < Error; end
end
