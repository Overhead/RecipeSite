RecipeSite::Application.routes.draw do
  
  resources :recipe
  resources :search_recipes
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  get "/searchRecipe" => "search_recipes#search_recipes"
  
  # You can have the root of your site routed with "root"
  root 'search_recipes#search_recipes'


  # Auth callback route
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

end
