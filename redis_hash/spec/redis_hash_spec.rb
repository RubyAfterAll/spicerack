# frozen_string_literal: true

RSpec.describe RedisHash do
  it_behaves_like "a versioned spicerack gem"

  describe RedisHash::AlreadyDefinedError do
    it { is_expected.to inherit_from StandardError }
  end
end
