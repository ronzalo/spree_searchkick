module Spree::PropertyDecorator
  def self.prepended(base)
    base.scope :filterable, -> { where(filterable: true) }
  end

  def filter_name
    name.downcase.to_s
  end
end

Spree::Property.prepend(Spree::PropertyDecorator)
