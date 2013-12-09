RecipeSite::Application.routes.draw do
  
  get "errors/server_error"
  get "errors/not_found"
  get "/recipe/search" => "recipe#search_index"
  resources :recipe, :except => [:index]
  resources :user
  resources :favorite
  resources :ingredient
  
  get "/profile" => "profile#show"
  resources :profile
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  get "/login" => "user#login"
  get "/profile/update" => "profile#update"
  get "/profile/:id" => "user#profile"
  post "/recipe/:id/fav" => "favorite#fav_recipe"
  post "/recipe/:id/unfav" => "favorite#unfav_recipe"

  get "/api/list" => "api#get_recipes"
  get "/api/find/:id" => "api#get_recipe"
  
  # You can have the root of your site routed with "root"
  root 'recipe#search_index'
  
  # Auth callback route
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout
  
  get '*unmatched_route', :to => 'application#raise_not_found!'

end
