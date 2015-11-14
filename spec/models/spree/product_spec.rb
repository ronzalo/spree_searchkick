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
  end
end
