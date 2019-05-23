# frozen_string_literal: true

class TaskRedisModel < Spicerack::RedisModel
  field :started_at, :datetime
  field :finished_at, :datetime
end

class ProcessorRedisModel < TaskRedisModel
  field :count, :integer, default: 42
  field :rate, :float, default: 3.14
end
