# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::WithFirstElement do
  describe '#validate!' do
    subject(:enforcer) { described_class.new(items, new_items) }

    context 'when items contain elements' do
      let(:items) { [42] }

      context 'when a single item with mismatching type is passed' do
        let(:new_items) { ["string"] }

        it 'raises' do
          expect {
            enforcer.validate!
          }.to raise_error(Collectible::ItemTypeMismatchError, /item mismatch/)
        end
      end

      context 'when multiply items with mismatching type are passed' do
        let(:new_items) { ["string1", "string2"] }

        it 'raises' do
          expect {
            enforcer.validate!
          }.to raise_error(Collectible::ItemTypeMismatchError, /item mismatch/)
        end
      end

      context 'when both matching and mismatching items are passed' do
        let(:new_items) { [42, "string", 43] }

        it 'raises' do
          expect {
            enforcer.validate!
          }.to raise_error(Collectible::ItemTypeMismatchError, /item mismatch/)
        end
      end

      context 'when all new elements are valid' do
        let(:new_items) { [137] }

        it 'does not raise' do
          expect(enforcer.validate!).to be_truthy
        end
      end
    end

    context 'when items is empty' do
      let(:items) { [] }

      context 'when a single new element is passed' do
        let(:new_items) { ["string"] }

        it 'allows any new first item' do
          expect(enforcer.validate!).to be_truthy
        end
      end

      context 'when multiple elements with mismatching types are passed' do
        let(:new_items) { [42, "string", 43] }

        it 'raises' do
          expect {
            enforcer.validate!
          }.to raise_error(Collectible::ItemTypeMismatchError, /item mismatch/)
        end
      end
    end
  end
end
