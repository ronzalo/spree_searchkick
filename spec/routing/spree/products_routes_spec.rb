require 'spec_helper'

RSpec.describe Spree::ProductsController, type: :routing do
  describe 'routing' do
    routes { Spree::Core::Engine.routes }
    let(:taxon) { create(:taxon) }

    context 'best selling products' do
      it 'routes to #best_selling' do
        expect(get: best_path).to route_to(controller: 'spree/products', action: 'best_selling')
      end
    end

    context 'best selling products by taxon' do
      it 'routes to #create' do
        expect(get: best_selling_taxon_path(taxon.permalink)).to route_to(controller: 'spree/products', action: 'best_selling', id: taxon.permalink)
      end
    end
  end
end
