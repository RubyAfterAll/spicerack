# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::WithType do
  subject(:enforcer) { described_class.new(existing_items, new_items, validate_with: type) }
  describe "#validate!" do
    context 'when new items are valid' do
      let(:existing_items) { [1, 2, 3] }
      let(:new_items) { [5, 6] }
      let(:type) { Integer }

      it 'does not raise' do
        expect(enforcer.validate!).to be_truthy
      end
    end

    context 'when at least one item is invalid' do
      let(:existing_items) { [1, 2, 3] }
      let(:new_items) { [5, 6] }
      let(:type) { String }

      it 'raises ItemTypeMismatchError' do
        expect {
          enforcer.validate!
        }.to raise_error(Collectible::ItemTypeMismatchError)
      end
    end
  end
end
