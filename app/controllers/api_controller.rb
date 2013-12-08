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
  
end
