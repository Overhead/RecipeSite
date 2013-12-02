class RecipeController < ApplicationController
  respond_to :xml, :json, :html
  def index
    if current_user
      @recipes = Recipe.where("users_id = ?", current_user.id)
      respond_with(@recipe)
    else
      require_login
    end 
  end
  
  def search_index
    @cuisineList = ['American', 'Italian', 'Asian', 'Mexican', 'French', 'Southwestern', 'Barbecue', 'Indian', 'Chinese', 'English', 'Mediterranean', 'Greek', 'Spanish', 'German', 'Thai', 'Moroccan', 'Irish', 'Japanese', 'Cuban', 'Hawaiin', 'Swedish', 'Hungarian', 'Portugese']
    unless params[:search_string].blank?
      @requesturl = Recipe.get_request_url(request.url,request.env['HTTP_HOST'])
      @recipeResult = Recipe.get_recipes_from_api(params)
      respond_to do |format|
      format.html { }
        format.js   {}
        format.json { render json: @recipeResult }
      end
    end
  end
  
  def show
    if Recipe.where("id = ?", params[:id]).blank?
       @recipe = Recipe.get_recipe_from_api(params[:id])
     else
       @dbRecipe = Recipe.find(params[:id])
       @recipe = Recipe.get_recipe_hash(@dbRecipe)
    end
    respond_with(@recipe)
  end
  
  def fav_recipe
    if Recipe.where("id = ?", params[:id]).blank?
      if Recipe.where("yummly_id = ?", params[:id]).blank?
        Recipe.create_yummly_recipe(params, current_user)
        respond_to do |format|
          format.js
        end
        #create yummly recipe, and recipe fav connection to user
      else
        #create only recipe fav connection to user
      end
    end
  end
  
  def unfav_recipe
    respond_to do |format|
          format.js
    end
  end
  
end
