# frozen_string_literal: true

class ExampleHashModelBase
  include Spicerack::HashModel

  class << self
    def for(data)
      new.tap { |model| model.data = data }
    end
  end
end

class ExampleHashModelParent < ExampleHashModelBase
  field :started_at, :datetime
  field :finished_at, :datetime
end

class ExampleHashModel < ExampleHashModelParent
  field :count, :integer, default: 42
  field :rate, :float, default: 3.14
end
