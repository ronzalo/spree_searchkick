Spree::ProductsHelper.module_eval do
  def cache_key_for_products
    count = @products.count
    hash = Digest::SHA1.hexdigest(params.to_json)
    max_updated_at = @products.map(&:updated_at).max || Date.today
    "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{hash}-#{count}-#{max_updated_at.to_s(:number)}"
  end
end
