# frozen_string_literal: true

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
