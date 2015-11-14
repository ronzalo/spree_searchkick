Spree::Order.class_eval do
  Spree::Order.state_machine.after_transition to: :complete, do: :reindex_order_products

  def reindex_order_products
    return unless complete?
    products.map(&:reindex)
  end
end
