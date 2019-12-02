# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::Base do
  subject(:enforcer) do
    described_class.new(
      [1, 2, 3],
      [4, 5]
    )
  end

  describe "#validate!" do
    it 'is abstract' do
      expect {
        enforcer.validate!
      }.to raise_error(NotImplementedError, /must implement method #publish!/)
    end
  end
end
