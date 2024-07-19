module SpreeSearchkick
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_searchkick'

    config.autoload_paths += %W[#{config.root}/lib]

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.before_initialize do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :helper, SpreeSearchkick::ProductsHelper
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Spree::Config.searcher_class = Spree::Search::Searchkick
    end

    config.to_prepare &method(:activate).to_proc
  end
end
