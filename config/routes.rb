Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/best', to: 'products#best_selling'
  get '/best/t/*id/', to: 'products#best_selling', as: :best_selling_taxon
  get '/autocomplete/products', to: 'products#autocomplete', as: :autocomplete
end
