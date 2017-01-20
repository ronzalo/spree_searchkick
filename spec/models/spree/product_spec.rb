require 'spec_helper'
require 'pry'

RSpec.describe Spree::Product, type: :model do
  describe 'searches' do
    let(:product) { create(:product) }

    it 'autocomplete by name' do
      keyword = product.name[0..6]
      Spree::Product.reindex
      expect(Spree::Product.autocomplete(keyword)).to eq([product.name.strip])
    end

    context 'products that are not yet available' do
      let(:product) { create(:product, available_on: nil) }

      it 'does not return them in autocomplete' do
        keyword = product.name[0..6]
        Spree::Product.reindex
        expect(Spree::Product.autocomplete(keyword)).to eq([])
      end
    end

    context 'products with no price' do
      let(:product) do
        create(:product).tap { |_| Spree::Price.update_all(amount: nil) }
      end

      it 'does not return them in autocomplete' do
        keyword = product.name[0..6]
        Spree::Product.reindex
        expect(Spree::Product.autocomplete(keyword)).to eq([])
      end
    end
  end
end
