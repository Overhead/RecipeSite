class SearchRecipesController < ApplicationController
  respond_to :xml, :json, :html
  
  def index
    @recipeResult = nil
  end
    
  def search_recipes
    @recipeResult = Recipe.get_recipes_from_api()
    respond_to do |format|
    format.html { redirect_to @search_recipe }
      format.js   {}
      format.json { render json: @recipeResult }
    end
  end 
    
end
