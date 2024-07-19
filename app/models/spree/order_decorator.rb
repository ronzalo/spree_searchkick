module Spree::OrderDecorator
  def self.prepended(base)
    base.state_machine.after_transition to: :complete, do: :reindex_order_products
  end

  def reindex_order_products
    return unless complete?
    products.map(&:reindex)
  end
end

Spree::Order.prepend(Spree::OrderDecorator)