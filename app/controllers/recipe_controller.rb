class RecipeController < ApplicationController
  respond_to :xml, :json, :html
  def index
    @recipe = Recipe.all
    respond_with(@recipe)
  end
  
end
