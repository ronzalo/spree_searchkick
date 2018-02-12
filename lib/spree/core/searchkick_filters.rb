module Spree
  module Core
    module SearchkickFilters
      def self.applicable_filters(aggregations)
        es_filters = []
        Spree::Taxonomy.filterable.each do |taxonomy|
          es_filters << process_filter(taxonomy.filter_name, :taxon, aggregations[taxonomy.filter_name])
        end

        Spree::Property.filterable.each do |property|
          es_filters << process_filter(property.filter_name, :property, aggregations[property.filter_name])
        end

        es_filters.uniq
      end

      def self.process_filter(name, type, filter)
        options = []
        case type
        when :price
          min = filter['buckets'].min_by { |a| a['key'] }
          max = filter['buckets'].max_by { |a| a['key'] }
          options = if min && max
                      { min: min['key'].to_i, max: max['key'].to_i, step: 100 }
                    else
                      {}
                    end
        when :taxon
          ids = filter['buckets'].map { |h| h['key'] }
          taxons = Spree::Taxon.where(id: ids).order(name: :asc)
          taxons.each { |t| options << { label: t.name, value: t.id } }
        when :property
          values = filter['buckets'].map { |h| h['key'] }
          values.each { |t| options << { label: t, value: t } }
        end

        {
          name: name,
          type: type,
          options: options
        }
      end

      def self.aggregation_term(aggregation)
        aggregation['buckets'].sort_by { |hsh| hsh['key'] }
      end
    end
  end
end
