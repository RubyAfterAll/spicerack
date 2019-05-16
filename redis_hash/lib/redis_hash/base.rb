# frozen_string_literal: true

require_relative "concerns/adapter"
require_relative "concerns/default"
require_relative "concerns/callbacks"
require_relative "concerns/core"
require_relative "concerns/identity"
require_relative "concerns/accessors"
require_relative "concerns/comparisons"
require_relative "concerns/predicates"
require_relative "concerns/insertions"
require_relative "concerns/deletions"
require_relative "concerns/enumerators"
require_relative "concerns/mutations"
require_relative "concerns/converters"

module RedisHash
  class Base
    include Technologic
    include RedisHash::Adapter
    include RedisHash::Default
    include RedisHash::Callbacks
    include RedisHash::Core
    include RedisHash::Identity
    include RedisHash::Accessors
    include RedisHash::Comparisons
    include RedisHash::Predicates
    include RedisHash::Insertions
    include RedisHash::Deletions
    include RedisHash::Enumerators
    include RedisHash::Mutations
    include RedisHash::Converters
  end
end
