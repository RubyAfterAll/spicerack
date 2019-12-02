# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::WithProc do
  subject(:enforcer) do
    described_class.new(
      existing_items,
      new_items,
      validate_with: validation_proc
    )
  end

  describe "#validate!" do
    context 'when new items are valid' do
      let(:existing_items) { [42, 17, 137] }
      let(:new_items) { [3.14, 2.71] }

      let(:validation_proc) { ->(new_item) { true } }

      it 'does not raise' do
        expect(enforcer.validate!).to be_truthy
      end
    end

    context 'when at least one item is invalid' do
      let(:existing_items) { [42, 17, 137] }
      let(:new_items) { ['invalid items sample'] }

      let(:validation_proc) { ->(new_item) { false } }

      it 'raises ItemNotAllowed' do
        expect {
          enforcer.validate!
        }.to raise_error(Collectible::ItemNotAllowedError)
      end
    end
  end
end
