class RecipeController < ApplicationController
  respond_to :xml, :json, :html
  def index
    @recipes = Recipe.all
    respond_with(@recipe)
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    respond_with(@recipe)
  end
  
end
