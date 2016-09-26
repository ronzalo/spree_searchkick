require 'spec_helper'

RSpec.describe Spree::Product, type: :model do
  describe 'searches' do
    let(:product) { create(:product) }

    before do
      product.reindex
      Spree::Product.reindex
    end

    it 'autocomplete by name' do
      keyword = product.name[0..3]
      expect(Spree::Product.autocomplete(keyword)).to eq([product.name.strip])
    end

    context 'products that are not yet available' do
      let(:product) { create(:product, available_on: nil) }

      it 'does not return them in autocomplete' do
        keyword = product[0..3]
        expect(Spree::Product.autocomplete(keyword)).to eq([])
      end
    end

    context 'products with no price' do
      let(:product) do
        create(:product).tap { |_| Spree::Price.update_all(amount: nil) }
      end

      it 'does not return them in autocomplete' do
        keyword = product[0..3]
        expect(Spree::Product.autocomplete(keyword)).to eq([])
      end
    end
  end
end
