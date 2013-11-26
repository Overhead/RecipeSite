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
  
  def show
    @recipe = Recipe.find(params[:id])
    respond_with(@recipe)
  end
  
end
