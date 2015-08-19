Spree::ProductsHelper.module_eval do
  def cache_key_for_products
    count = @products.count
    hash = Digest::SHA1.hexdigest(params.to_json)
    "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{params}-#{count}"
  end
end