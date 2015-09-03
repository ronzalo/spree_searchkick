Spree::ProductsController.class_eval do
  def best_selling
    @searcher = build_searcher(params.merge(conversions: true))
    @products = @searcher.retrieve_products
    @taxonomies = []
    render action: :index
  end
end