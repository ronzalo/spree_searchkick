require 'spec_helper'
require 'pry'

RSpec.describe Spree::ProductsController, type: :controller do
  describe 'GET best_selling' do
    let(:order) { create(:completed_order_with_totals) }

    context 'when empty taxon' do
      it 'get from all products sort by conversions desc' do
        order.reindex_order_products
        get :best_selling
        expect(assigns(:products)).to be_a(Searchkick::Results)
      end
    end

    context 'when best by taxon' do
      let(:taxon) { create(:taxon) }
      let(:regular_product) { create(:product, name: 'regular', taxons: [taxon]) }

      before(:each) do
        @product = order.products.sample
        regular_product.reindex
        taxon.products << @product
        Spree::Product.reindex
      end

      it 'sort by conversions desc' do
        order.reindex_order_products
        get :best_selling, params: { id: taxon }

        expect(assigns(:products).map(&:name)).to eq [@product.name, 'regular']
      end

      it 'get same products qty' do
        get :best_selling, params: { id: taxon }
        expect(assigns(:products).count).to eq(2)
      end

      it 'return a Searchkick::Results' do
        get :best_selling, params: { id: taxon }
        expect(assigns(:products)).to be_a(Searchkick::Results)
      end
    end
  end
end
