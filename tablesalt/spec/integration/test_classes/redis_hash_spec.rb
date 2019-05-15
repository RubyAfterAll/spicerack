# frozen_string_literal: true

require_relative "../../support/test_classes/redis_hash"

RSpec.describe RedisHash, type: :integration do
  subject { described_class }

  it { is_expected.to inherit_from Tablesalt::RedisHashBase }
end
