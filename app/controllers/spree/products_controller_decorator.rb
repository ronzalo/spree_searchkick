Spree::ProductsController.class_eval do
  before_filter :load_taxon, only: [:best_selling]

  def best_selling
    params.merge(taxon: @taxon.id) if @taxon
    @searcher = build_searcher(params.merge(conversions: true))
    @products = @searcher.retrieve_products
    render action: :index
  end

  def autocomplete
    keywords = params[:keywords] ||= nil
    json = Spree::Product.autocomplete(keywords)
    render json: json
  end

  private

  def load_taxon
    @taxon = Spree::Taxon.friendly.find(params[:id])
  end
end
