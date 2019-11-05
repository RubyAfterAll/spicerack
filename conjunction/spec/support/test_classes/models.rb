# frozen_string_literal: true

require "active_model/naming"

class ApplicationSchmodel
  extend ActiveModel::Naming

  include Conjunction::Conjunctive
end

module GalacticFederation
  class Earthling < ApplicationSchmodel; end
end

class Martian < ApplicationSchmodel; end
class PlanetaryAddress < ApplicationSchmodel; end
