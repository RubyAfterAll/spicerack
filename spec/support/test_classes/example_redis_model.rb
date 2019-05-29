# frozen_string_literal: true

class ExampleRedisModelParent < Spicerack::RedisModel
  field :started_at, :datetime
  field :finished_at, :datetime
end

class ExampleRedisModel < ExampleRedisModelParent
  field :count, :integer, default: 42
  field :rate, :float, default: 3.14
end
