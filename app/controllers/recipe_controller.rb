class RecipeController < ApplicationController
  respond_to :xml, :json, :html
  def index
    @recipe = Recipe.all
    respond_with(@recipe)
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @ingred = Ingredient.find(1)
    respond_with(@recipe)
  end
  
end
