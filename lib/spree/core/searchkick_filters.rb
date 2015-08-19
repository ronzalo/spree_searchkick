module Spree
  module Core
    module SearchkickFilters
      def self.applicable_filters(facets)
        es_filters = []
        Spree::Taxonomy.filterable.each do |taxonomy|
          es_filters << self.process_filter(taxonomy.filter_name, :taxon, facets[taxonomy.filter_name])
        end
        es_filters
      end

      def self.process_filter(name, type, filter)
        options = []
        case type
        when :price
          min = filter["terms"].min {|a,b| a["term"] <=> b["term"] }
          max = filter["terms"].max {|a,b| a["term"] <=> b["term"] }
          if min && max
            options = {min: min["term"].to_i, max: max["term"].to_i, step: 100}
          else
            options = {}
          end
        when :taxon
          ids = filter["terms"].map{|h| h["term"]}
          taxons = Spree::Taxon.where(id: ids).order(name: :asc)
          taxons.each {|t| options << {label: t.name, value: t.id }}
        end

        {
          name: name,
          type: type,
          options: options
        }

      end

      def self.facet_term(facet)
        facet["terms"].sort_by { |hsh| hsh["term"] }
      end
    end
  end
end