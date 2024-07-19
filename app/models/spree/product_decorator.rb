module Spree::ProductDecorator
  def self.prepended(base)
    base.searchkick word_start: searchkick_fields, settings: { number_of_replicas: 0 } unless base.respond_to?(:searchkick_index)

    def base.autocomplete_fields
      [:name]
    end

    def base.search_fields
      [:name]
    end

    def base.autocomplete(keywords)
      if keywords
        Spree::Product.search(
          keywords,
          fields: autocomplete_fields,
          match: :word_start,
          limit: 10,
          load: false,
          misspellings: { below: 3 },
          where: search_where
        ).map(&:name).map(&:strip).uniq
      else
        Spree::Product.search(
          '*',
          fields: autocomplete_fields,
          load: false,
          misspellings: { below: 3 },
          where: search_where
        ).map(&:name).map(&:strip)
      end
    end

    def base.search_where
      {
        active: true,
        price: { not: nil }
      }
    end
  end

  def search_data
    json = {
      active: available?,
      created_at:,
      updated_at:,
      price:,
      currency:,
      conversions: orders.complete.count,
      taxon_ids: taxon_and_ancestors.map(&:id),
      taxon_names: taxon_and_ancestors.map(&:name)
    }

    active_locales.each do |locale|
      translation = translations.find_by(locale:)
      json["name_#{locale}"] = translation&.name
      json["description_#{locale}"] = translation&.description
      json["short_description_#{locale}"] = translation&.short_description
    end

    Spree::Property.all.each do |prop|
      json.merge!(Hash[prop.name.downcase, property(prop.name)])
    end

    Spree::Taxonomy.all.each do |taxonomy|
      json.merge!(Hash["#{taxonomy.name.downcase}_ids", taxon_by_taxonomy(taxonomy.id).map(&:id)])
    end

    json
  end  

  def taxon_by_taxonomy(taxonomy_id)
    taxons.joins(:taxonomy).where(spree_taxonomies: { id: taxonomy_id })
  end

  def self.searchkick_fields
    fields = []
    locales = Spree::Store.current.supported_locales.split(',').map(&:to_sym) << Spree::Store.current.default_locale.to_sym
    locales.uniq.each do |locale|
      fields << :"name_#{locale}"
      fields << :"description_#{locale}"
      fields << :"short_description_#{locale}"
    end
    fields
  end

  def active_locales
    default_locale = Spree::Store.current.default_locale.to_sym
    supported_locales = Spree::Store.current.supported_locales.split(',').map(&:to_sym)
    (supported_locales << default_locale).uniq
  end
end

Spree::Product.prepend(Spree::ProductDecorator)
