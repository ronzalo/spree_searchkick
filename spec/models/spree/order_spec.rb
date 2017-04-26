require 'spec_helper'

RSpec.describe Spree::Order, type: :model do
  describe '#reindex_order_products' do
    context 'when order is completed' do
      let(:order) { create(:completed_order_with_totals) }

      before(:each) do
        Spree::Product.searchkick_index.refresh
        Spree::Product.reindex
      end

      it 'reindex order items after transition to complete' do
        order.reindex_order_products
        product = order.products.first
        expect(product.search_data[:conversions]).to eq(1)
      end
    end
  end
end
