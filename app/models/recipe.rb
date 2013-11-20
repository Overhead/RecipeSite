class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, :through => :recipe_ingredients
  has_many :users, :through => :user_recipe_history
  has_many :users, :through => :user_recipe_favourites
  
  
  require "net/http"
  require "uri"
  require 'json'
  
  def self.get_request_url(full_path, host_path)
    full_path.gsub("http://"+host_path, "")
  end
  
  
  def self.get_recipes_from_api(params)
    
    apiAuthString = "http://api.yummly.com/v1/api/recipes?_app_id="+ENV['APP_ID']+"&_app_key="+ENV['APP_KEY']
    apiSearchString = ""
    
    if params[:search_string]
      apiSearchString += getAPISearchString(params[:search_string])
    end
    
    if params[:checked_cuisines]
      apiSearchString += getAllowedCuisineString(params[:checked_cuisines])
    end
    
    if params[:max_minutes].to_i > 0
      apiSearchString += "&maxTotalTimeInSeconds="+(params[:max_minutes].to_i * 60).to_s
    end
    
    puts apiSearchString
    uri = URI.parse(apiAuthString+apiSearchString)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    Net::HTTP.get_print(uri)
    # Full
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    parsed = JSON.parse(response.body)
  end

  def self.getAPISearchString(search_string)
    allowedIngredientString = ""
    
    if search_string.include? ";"
      newlist =  search_string.split(/;\s*/)
      allowedIngredientString += "&q="+newlist[0].to_s.gsub(" ", "+")
      search_string = (newlist[1] != nil ? newlist[1] : "")
    end
    
    #Remove all newlines, and long spaces, then split string into array with each ingredient
    search_string.squish.split(/,\s*/).each do |ingred|
      allowedIngredientString += "&allowedIngredient[]="+ingred
    end
    return allowedIngredientString
  end
  
  def self.getAllowedCuisineString(cuisines)
    includeCuisineString = ""
    cuisines.each do |key, value|
      includeCuisineString += "&allowedCuisine[]=cuisine%5Ecuisine-"+value.downcase
    end
    return includeCuisineString 
  end

  def self.get_recipe_from_api(id)
    apiAuthString = "http://api.yummly.com/v1/api/recipe/"+id+"?_app_id="+ENV['APP_ID']+"&_app_key="+ENV['APP_KEY']
    uri = URI.parse(apiAuthString)
    # Shortcut
    response = Net::HTTP.get_response(uri)
    # Will print response.body
    Net::HTTP.get_print(uri)
    # Full
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    parsed = JSON.parse(response.body)
  end

end
