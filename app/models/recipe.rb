class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, :dependent => :destroy
  has_many :ingredients, :through => :recipe_ingredients
  has_many :recipe_images, :dependent => :destroy
  accepts_nested_attributes_for :recipe_ingredients
  accepts_nested_attributes_for :recipe_images
  belongs_to :user
  
  require "net/http"
  require "uri"
  require 'json'

  
  def self.get_request_url(full_path, host_path)
    full_path.gsub("http://"+host_path, "")
  end
  
  def self.get_search_recipes(params)
    
    recipe_db_hash_list = [] #List used to store db recipe hashes
    recipe_yummly_hash_list = [] #List used to store yummly recipe hashes
    recipeList = get_recipes_from_db(params) #All recipes from DB
    
    params_page = params[:new_page] ? params[:new_page] : 0
    page = params_page.to_i / 12      #0 = first page, 1,2,n rest pages
    pagesInDB = (recipeList.count / 12).floor #Get the number of pages that the db recipes will generate
    offset = recipeList.count % 12 #How many recipes we have to get from elsewhere
      
    total_yummly_hash = get_yummly_hash(params, page, pagesInDB, offset) #Get the number of yummmly hashes
    yummly_list = total_yummly_hash['matches']   #Get the list of recipes from yummly
    
    #Create hash from recipes from DB and insert into db_hash_list
    recipeList.each { |recipe|
      unless recipe.blank?
        recipe_hash = {
          "id" => recipe.id,
          "recipeName" => recipe.recipeName,
          "imageUrls" => [],
          "totalTimeInSeconds" => recipe.totalTimeInSeconds,
          "rating" => recipe.rating,
          "ingredients" => [] 
        }
        
        recipe.recipe_images.each {|img| recipe_hash['imageUrls'].push(img.image_url)}
        recipe.ingredients.each {|ing| recipe_hash['ingredients'].push(ing)}
        
        recipe_db_hash_list.push(recipe_hash)
      end
    }

    #Create hash for each recipe from Yummly, and inserting into yummly_hash_list
    yummly_list.each { |recipe|
        recipe_hash = {
          "id" => recipe['id'],
          "recipeName" => recipe['recipeName'],
          "imageUrls" => [recipe['smallImageUrls'].first],
          "totalTimeInSeconds" => recipe['totalTimeInSeconds'],
          "rating" => recipe['rating'],
          "ingredients" => [] 
      }
      recipe['ingredients'].each {|ing| recipe_hash['ingredients'].push(ing)}
      recipe_yummly_hash_list.push(recipe_hash)
    }
    
    #The final list that only shall show 12 recipes
    presentation_list = recipe_db_hash_list[page*12, (page*12)+12]
    
    #If the list is nil, it is no recipes from the DB in it
    if presentation_list.nil?
      presentation_list = recipe_yummly_hash_list
    elsif presentation_list.count < 12 #If there is ex only 2 recipes from db, insert 10 from yummly
      presentation_list = presentation_list.concat(recipe_yummly_hash_list)
    end
        
    #The final hash that is sent to view
    final_recipe_hash = {
        "totalMatchCount" => "",
        "matches" => []      
    }

    #Insert the list of all recipes for given page, and set total number of recipes found
    final_recipe_hash['matches'] = presentation_list
    final_recipe_hash['totalMatchCount'] = (total_yummly_hash['totalMatchCount'].to_i + recipeList.count).to_s
    return final_recipe_hash
  end  
    
  def self.get_recipes_from_db(params)
    recipeList = []
    search_string = params[:search_string]
    puts params[:search_string]
    
    if search_string.include? ";"
      search_string_array = search_string.split(/;\s*/)
      recipeName = search_string_array[0].to_s
      Recipe.where('recipeName LIKE ?', '%'+recipeName+'%').each {|r| recipeList.push(r) }
      search_string = (search_string_array[1] != nil) ? search_string_array[1] : ""
      puts search_string
    end
    
        search_string.squish.split(/,\s*/).each do |ingred|
          Ingredient.where("title like ?", ingred.to_s).each{|ing| ing.recipes.each{|r| recipeList.push(r)}}     
    end
    
    return recipeList.uniq
  end
  
  def self.get_yummly_hash(params, requestPage, pagesInDB, offset)
    if pagesInDB >= requestPage
      return get_recipes_from_api(params, 0, (12-offset) == 0 ? 1 : (12-offset))
    else
      start_at = ((requestPage - pagesInDB) *12) - offset
      return get_recipes_from_api(params, start_at, 12)
    end
  end
  
  def self.get_recipes_from_api(params, start, max_result)
        
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
    apiSearchString += "&maxResult="+max_result.to_s+"&start="+ start.to_s
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
    
    recipeHash = {
        "id" => parsed['id'], 
        "recipeName" => parsed['name'],
        "rating" => parsed['rating'],
        "totalTimeInSeconds" => parsed['totalTimeInSeconds'],
        "images" => [parsed['images'][0]['hostedLargeUrl']],
        "ingredients" => [],
        "source" => "yummly",
        "created_by" => {
                    "id" => "",
                    "name" => parsed['source']['sourceSiteUrl']
                },
        "description" => parsed['source']['sourceRecipeUrl']
      }
      parsed['ingredientLines'].each { |line| 
          line_list = splitIngredientLine(line)
          puts line
          ingredient_hash = {}
          if line_list.size > 3
            ingredient_hash = { 
                            "amount" => line_list[1], 
                            "unit" => line_list[2],
                            "name" => line_list[3]
                             }
          elsif line_list.count == 1 #If there is only a name, for example: bacon bits
              ingredient_hash = { 
                          "amount" => nil, 
                          "unit" => nil,
                          "name" => line_list[0]
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
        "source" => "RecipeSite",
        "created_by" => {
                    "id" => recipe.user_id,
                    "name" => recipe.user.name
                },
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
