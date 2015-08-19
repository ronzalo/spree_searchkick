module Spree::Search
  class Searchkick < Spree::Core::Search::Base
    def retrieve_products
      @products = get_base_elasticsearch
    end

    def get_base_elasticsearch
      curr_page = page || 1
      query = (keywords.nil? || keywords.empty?) ? "*" : keywords
      Spree::Product.search(query, where: where_query, facets: facets, smart_facets: true, page: curr_page, per_page: per_page)
    end

    def where_query
      where_query = {
        active: true,
        currency: current_currency,
        price: {not: nil}
      }
      where_query.merge!({taxon_ids: taxon.id}) if taxon
      add_search_filters(where_query)
    end

    def facets
      fs = []
      Spree::Taxonomy.filterable.each do |taxonomy|
        fs << taxonomy.filter_name.to_sym
      end
      fs
    end

    def add_search_filters(query)
      return query unless search
      search.each do |name, scope_attribute|
        query.merge!(Hash[name, scope_attribute])
      end
      query
    end

    def get_base_scope
      base_scope = Spree::Product.active
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = add_search_scopes(base_scope)
      base_scope = add_eagerload_scopes(base_scope)
      base_scope
    end
  end
end