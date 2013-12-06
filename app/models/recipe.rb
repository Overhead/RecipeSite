class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients, :through => :recipe_ingredients
  has_many :recipe_images, :dependent => :destroy
  
  require "net/http"
  require "uri"
  require 'json'
  
  def self.get_request_url(full_path, host_path)
    full_path.gsub("http://"+host_path, "")
  end
  
  def self.get_search_recipes(params)
    
    #Used to decide what in the list we shall return, start, end
    #If params is bigger thant 12(page 2++), it shall start at new_page value - 12, else it is first page
    #recipeListStart = params[:new_page] && params[:new_page].to_i >= 12 ? (params[:new_page].to_i - 12) : 0 
    #recipeListEnd = params[:new_page] && params[:new_page].to_i >= 12 ? params[:new_page].to_i : 12 
    
    #params[:new_page] = 12 24 36 48
    
    recipeListHash = {
        "totalMatchCount" => "",
        "matches" => []      
    }
    
    recipeList = get_recipes_from_db()
    # recipeList.each { |recipe|
      # unless recipe.blank?
        # recipe_hash = {
          # "id" => recipe.id,
          # "recipeName" => recipe.recipeName,
          # "imageUrls" => [],
          # "totalTimeInSeconds" => recipe.totalTimeInSeconds,
          # "rating" => recipe.rating,
          # "ingredients" => [] 
        # }
#         
        # recipe.recipe_images.each {|img| recipe_hash['imageUrls'].push(img.image_url)}
        # recipe.ingredients.each {|ing| recipe_hash['ingredients'].push(ing)}
#         
        # recipeListHash['matches'].push(recipe_hash)
      # end
    # }
                
    #Get data from the API
    yummly_hash = get_recipes_from_api(params)  
    yummly_hash['matches'].each { |recipe|
        recipe_hash = {
          "id" => recipe['id'],
          "recipeName" => recipe['recipeName'],
          "imageUrls" => [recipe['smallImageUrls'].first],
          "totalTimeInSeconds" => recipe['totalTimeInSeconds'],
          "rating" => recipe['rating'],
          "ingredients" => [] 
      }
      recipe['ingredients'].each {|ing| recipe_hash['ingredients'].push(ing)}
      recipeListHash['matches'].push(recipe_hash)
    }
    
    recipeListHash['totalMatchCount'] = (yummly_hash['totalMatchCount'].to_i).to_s
    return recipeListHash
  end  
  
  def self.get_recipes_from_db(params)
    recipeList = []
    search_string = params[:search_string]
    
    if search_string.include? ";"
      search_string_array = search_string.split(/;\s*/)
      recipeName = search_strin_array[0].to_s
      Recipe.where('recipeName LIKE ?', '%'+recipeName+'%').each {|r| recipeList.push(r) }
      search_string = (search_string_array != nil) ? search_string_array[1] : ""
    end
    
    search_string.squish.split(/,\s*/).each do |ingred|
      Ingredient.where("title like ?", ingred.to_s).each{|ing| ing.recipes.each{|r| recipeList.push(r)}}   
    end
    
    return recipe
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
    
    #Smart if/else sentence, if it has params set start to that value, else start on 0   
    apiSearchString += params[:new_page] ? "&maxResult=12&start="+params[:new_page] : "&maxResult=12&start=0"

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
    
    recipeHash = {
        "id" => parsed['id'], 
        "recipeName" => parsed['name'],
        "rating" => parsed['rating'],
        "totalTimeInSeconds" => parsed['totalTimeInSeconds'],
        "images" => [parsed['images'][0]['hostedLargeUrl']],
        "ingredients" => [],
        "source" => "yummly",
        "description" => parsed['source']['sourceRecipeUrl']
      }
      parsed['ingredientLines'].each { |line| 
          line_list = splitIngredientLine(line)
          ingredient_hash = {}
          if line_list.size > 3
            ingredient_hash = { 
                            "amount" => line_list[1], 
                            "unit" => line_list[2],
                            "name" => line_list[3]
                             }
          else
             ingredient_hash = { 
                          "amount" => line_list[1], 
                          "unit" => nil,
                          "name" => line_list[2]
                           }
          end
          recipeHash['ingredients'].push(ingredient_hash)
      }
      return recipeHash
    
  end
  
  def self.splitIngredientLine(line)
    units = [
            'cup',
            'quart',
            'gallon',
            'pound',
            'pint',
            'ounce' ]
    joined_units = (units.collect{|u| u.pluralize} + units).join('|')
    ingredientList  = line.split(/([\d\/\.\s]+(\([^)]+\))?)\s(#{joined_units})?\s?(.*)/i)
  end
  
  def self.get_recipe_hash(recipe)
      recipeHash = {
        "id" => recipe.id, 
        "recipeName" => recipe.recipeName,
        "rating" => recipe.rating,
        "totalTimeInSeconds" => recipe.totalTimeInSeconds,
        "images" => [],
        "ingredients" => [],
        "source" => "db",
        "description" => recipe.description
      }
      
      #Add all the ingredients to the hash
      recipe.recipe_ingredients.each { |rec| 
          recipeHash['ingredients'].push({ 
                                "amount" => rec.amount, 
                                "unit" => rec.unit,
                                "name" => rec.ingredient.title })
      }
      #Add all the images to the hash
      recipe.recipe_images.each { |img| 
          recipeHash['images'].push(img.image_url)
        }
      
      return recipeHash
    end
     
end
