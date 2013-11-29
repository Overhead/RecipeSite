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
  
  def new     #GET /recipe/new
    @recipe = Recipe.new
  end

  def create  #POST /recipe
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      redirect_to @recipe
    else
      render "new"
    end
  end


  private
    def recipe_params
      params.require(:recipe)
    end
end
