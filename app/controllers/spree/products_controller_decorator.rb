Spree::ProductsController.class_eval do
  def best_selling
    if params[:id]
      @taxon = Spree::Taxon.find_by!(permalink: params[:id])
      @searcher = build_searcher(params.merge({conversions: true, taxon: @taxon.try(:id)}))
    else
      @searcher = build_searcher(params.merge(conversions: true))
    end
    @products = @searcher.retrieve_products
    @taxonomies = []
    render action: :index
  end
end