
require File.expand_path('../lib/spree_searchkick/version', __FILE__)

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_searchkick'
  s.version     = SpreeSearchkick::VERSION
  s.summary     = 'Add searchkick to spree'
  s.description = 'Filters, suggests, autocompletes, sortings, searches'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Gonzalo Moreno'
  s.email     = 'gmoreno@acid.cl'
  s.homepage  = 'http://www.acid.cl'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'searchkick'
  s.add_dependency 'spree_core', '>= 3.1.0', '< 4.0'

  s.add_development_dependency 'better_errors'
  s.add_development_dependency 'binding_of_caller'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'elasticsearch-extensions'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
