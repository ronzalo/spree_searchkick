Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  get '/best', to: 'products#best_selling'
end
