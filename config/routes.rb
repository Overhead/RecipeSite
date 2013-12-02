RecipeSite::Application.routes.draw do
  
  
  get "/recipe/search" => "recipe#search_index"
  resources :recipe
  resources :user
  
  get "/profile" => "profile#show"
  resources :profile
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  get "/login" => "user#login"
  get "/profile/update" => "profile#update"
  get "/profile/:id" => "user#profile"
  post "/recipe/:id/fav" => "recipe#fav_recipe"
  post "/recipe/:id/unfav" => "recipe#unfav_recipe"
  
  # You can have the root of your site routed with "root"
  root 'recipe#search_index'


  # Auth callback route
  get "/auth/:provider/callback", to: "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout

end
