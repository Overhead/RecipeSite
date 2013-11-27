RecipeSite::Application.routes.draw do
  
  resources :recipe
  resources :search_recipes
  resources :user
  
  get "/profile" => "profile#show"
  resources :profile
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  get "/login" => "user#login"
  get "/profile/update" => "profile#update"
  get "/profile/:id" => "user#profile"
  get "/recipe/:id" => "recipe#show"
  get "/searchRecipe" => "search_recipes#search_recipes"
  get "/searchRecipe/:id" => "search_recipes#show"
  
  # You can have the root of your site routed with "root"
  root 'search_recipes#search_recipes'


  # Auth callback route
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

end
