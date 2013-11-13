class Recipe < ActiveRecord::Base
  has_many :ingredients, :through => :recipe_ingredients
  has_many :user, :through => :user_recipe_history
  has_many :user, :through => :user_recipe_favourite
  
  
  require "net/http"
  require "uri"
  require 'json'
  
  def self.get_recipes_from_api()
    uri = URI.parse("http://api.yummly.com/v1/api/recipes?_app_id=3044c145&_app_key=1cef424e5a98c833444fce312467c24a&allowedIngredient[]=flour&allowedIngredient[]=milk")
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    Net::HTTP.get_print(uri)
    # Full
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    parsed = JSON.parse(response.body)['matches']
  end
  
end
