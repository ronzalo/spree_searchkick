module Spree
  module Core
    module SearchkickFilters
      def self.applicable_filters(aggregations)
        es_filters = []
        Spree::Taxonomy.filterable.each do |taxonomy|
          es_filters << self.process_filter(taxonomy.filter_name, :taxon, aggregations[taxonomy.filter_name])
        end

        Spree::Property.filterable.each do |property|
          es_filters << self.process_filter(property.filter_name, :property, aggregations[property.filter_name])
        end

        es_filters.uniq
      end

      def self.process_filter(name, type, filter)
        options = []
        case type
        when :price
          min = filter["buckets"].min {|a,b| a["key"] <=> b["key"] }
          max = filter["buckets"].max {|a,b| a["key"] <=> b["key"] }
          if min && max
            options = {min: min["key"].to_i, max: max["key"].to_i, step: 100}
          else
            options = {}
          end
        when :taxon
          ids = filter["buckets"].map{|h| h["key"]}
          taxons = Spree::Taxon.where(id: ids).order(name: :asc)
          taxons.each {|t| options << {label: t.name, value: t.id }}
        when :property
          values = filter["buckets"].map{|h| h["key"]}
          values.each {|t| options << {label: t, value: t }}
        end

        {
          name: name,
          type: type,
          options: options
        }

      end

      def self.aggregation_term(aggregation)
        aggregation["buckets"].sort_by { |hsh| hsh["key"] }
      end
    end
  end
end