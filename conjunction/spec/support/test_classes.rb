# frozen_string_literal: true

require "active_model/naming"

# ================================= #
#             JUNCTIONS             #
# ================================= #

class ApplicationFleeb
  include Conjunction::Junction

  suffixed_with "Fleeb"
end

class ApplicationChumble
  include Conjunction::Junction

  prefixed_with "Chumble::"
end

class ApplicationFroodNoop
  include Conjunction::Junction

  prefixed_with "Frood"
  suffixed_with "Noop"
end

class ApplicationDingleBop
  include Conjunction::Junction

  class << self
    def junction_key
      :fully_custom
    end

    def prototype_name
      name.chomp("Fiddlesticks")
    end

    private

    def conjunction_name_for(other_prototype)
      "#{other_prototype.prototype_name}Fiddlesticks"
    end
  end
end

# ================================= #
#        CONJUNCTIONS: Fleeb        #
# ================================= #

module GalacticFederation
  class EarthlingFleeb < ApplicationFleeb; end
  class SatelliteFleeb < ApplicationFleeb; end
end

class PlanetaryAddressFleeb < ApplicationFleeb; end

class StarlightFleeb < ApplicationFleeb; end
class GenericFleeb < ApplicationFleeb; end

# ================================= #
#               MODELS              #
# ================================= #

class ApplicationSchmodel
  extend ActiveModel::Naming

  include Conjunction::Conjunctive
end

module GalacticFederation
  class Earthling < ApplicationSchmodel; end
end

class Martian < ApplicationSchmodel; end
class PlanetaryAddress < ApplicationSchmodel; end

# ================================= #
#               POROS               #
# ================================= #

class ApplicationPoro
  include Conjunction::Conjunctive
end

module GalacticFederation
  class Satellite < ApplicationPoro; end
end

class Starlight < ApplicationPoro; end
class HighFrequencyRadioBurst < ApplicationPoro
  conjoins GenericFleeb
end

class Luna
  include Conjunction::Conjunctive

  conjoins GenericFleeb
end
