class Recipe < ActiveRecord::Base
  has_many :ingredients, :through => :recipe_ingredients
  has_many :user, :through => :user_recipe_history
  has_many :user, :through => :user_recipe_favourite
  
  
  require "net/http"
  require "uri"
  require 'json'
  
  def self.get_recipes_from_api()
    uri = URI.parse("http:")
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
