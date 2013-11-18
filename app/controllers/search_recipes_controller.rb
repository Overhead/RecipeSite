class SearchRecipesController < ApplicationController
  respond_to :xml, :json, :html
  
  def index
    @recipeResult = nil
    @cuisineList = ['American', 'Italian', 'Asian', 'Mexican', 'French', 'Southwestern', 'Barbecue', 'Indian', 'Chinese', 'English', 'Mediterranean', 'Greek', 'Spanish', 'German', 'Thai', 'Moroccan', 'Irish', 'Japanese', 'Cuban', 'Hawaiin', 'Swedish', 'Hungarian', 'Portugese'] 
  end
    
  def search_recipes
    @recipeResult = Recipe.get_recipes_from_api(params)
    respond_to do |format|
    format.html { redirect_to @search_recipe }
      format.js   {}
      format.json { render json: @recipeResult }
    end
  end 
    
end
