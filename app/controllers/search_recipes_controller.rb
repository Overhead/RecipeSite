class SearchRecipesController < ApplicationController
  respond_to :xml, :json, :html
  
  def index
  end
    
  def search_recipes
    @recipeResult = Recipe.get_recipes_from_api()
    respond_with(@recipeResult)
  end  
    
end
