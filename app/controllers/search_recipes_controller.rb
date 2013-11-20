class SearchRecipesController < ApplicationController
  respond_to :xml, :json, :html
  
  def index
  end
    
  def search_recipes
    @cuisineList = ['American', 'Italian', 'Asian', 'Mexican', 'French', 'Southwestern', 'Barbecue', 'Indian', 'Chinese', 'English', 'Mediterranean', 'Greek', 'Spanish', 'German', 'Thai', 'Moroccan', 'Irish', 'Japanese', 'Cuban', 'Hawaiin', 'Swedish', 'Hungarian', 'Portugese']
    unless params[:search_string].blank?
      @requesturl = Recipe.get_request_url(request.url,request.env['HTTP_HOST'])
      @recipeResult = Recipe.get_recipes_from_api(params)
      respond_to do |format|
      format.html { }
        format.js   {}
        format.json { render json: @recipeResult }
      end
    end
  end 
  
  def show
    #@recipe = Recipe.get_recipe_from_api(params[:id])
  end
    
end
