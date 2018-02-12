require 'elasticsearch/extensions/test/cluster'

RSpec.configure do |config|
  unless ENV['CI']
    config.before(:suite) { start_elastic_cluster }

    config.after(:suite) { stop_elastic_cluster }
  end

  SEARCHABLE_MODELS = [Spree::Product].freeze

  # create indices for searchable models
  config.before do
    SEARCHABLE_MODELS.each do |model|
      model.reindex
      model.searchkick_index.refresh
    end
  end

  # delete indices for searchable models to keep clean state between tests
  config.after do
    SEARCHABLE_MODELS.each do |model|
      model.searchkick_index.delete
    end
  end
end

def start_elastic_cluster
  ENV['TEST_CLUSTER_PORT'] = '9250'
  ENV['TEST_CLUSTER_NODES'] = '1'
  ENV['TEST_CLUSTER_NAME'] = 'spree_searchkick_test'

  ENV['ELASTICSEARCH_URL'] = "http://localhost:#{ENV['TEST_CLUSTER_PORT']}"

  return if Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.start(timeout: 10)
end

def stop_elastic_cluster
  return unless Elasticsearch::Extensions::Test::Cluster.running?
  Elasticsearch::Extensions::Test::Cluster.stop
end
