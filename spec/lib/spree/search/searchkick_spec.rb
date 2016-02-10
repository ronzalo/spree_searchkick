require 'spec_helper'
describe Spree::Search::Searchkick do
  let(:product) { create(:product) }

  before do
    product.reindex
    Spree::Product.reindex
  end

  describe "#retrieve_products" do
    it "returns matching products" do
      products = Spree::Search::Searchkick.new({}).retrieve_products
      expect(products.count).to eq 1
    end

    describe "aggregations" do
      let(:taxonomy) { Spree::Taxonomy.where(id: 1, name: "Category").first_or_create }

      before do
        product.taxons << taxonomy.root
        product.reindex
        Spree::Product.reindex
      end

      it "has no aggregations by default" do
        products = Spree::Search::Searchkick.new({}).retrieve_products
        expect(products.aggs).to be_nil
      end

      context "with a filterable taxonomy" do
        let(:taxonomy) { Spree::Taxonomy.where(id: 1, name: "Category", filterable: true).first_or_create }

        it "retrieves aggregations" do
          products = Spree::Search::Searchkick.new({}).retrieve_products

          expect(products.count).to eq 1
          expect(products.aggs["category_ids"]).to include("doc_count" => 1)
          expect(products.aggs["category_ids"]["buckets"]).to be_a Array
        end
      end
    end
  end
end