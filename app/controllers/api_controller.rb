class ApiController < ApplicationController
  respond_to :json
  
  def get_recipes
    if params[:search_string].blank?
     render json: {:error => "Error with search parameter"}, :status => 400
    else
      @recipeResult = Recipe.get_search_recipes(params)
      render json: @recipeResult 
    end
  end
  
  
  def get_recipe
    if params[:id].blank?
      render json: {:error => "Error with search parameter"}, :status => 400
    else
      begin
        if Recipe.where("id = ?", params[:id])
          @recipe = Recipe.get_recipe_hash(Recipe.find(params[:id]))
          render json: @recipe
        else
          @recipe = Recipe.get_recipe_from_api(params[:id])
          render json: @recipe
        end
      rescue => ex
        render json: {:error => "No result with given id"}, :status => 400
      end
    end
  end
  
end
