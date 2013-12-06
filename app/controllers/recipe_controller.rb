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
  
  def search_index
    @cuisineList = ['American', 'Italian', 'Asian', 'Mexican', 'French', 'Southwestern', 'Barbecue', 'Indian', 'Chinese', 'English', 'Mediterranean', 'Greek', 'Spanish', 'German', 'Thai', 'Moroccan', 'Irish', 'Japanese', 'Cuban', 'Hawaiin', 'Swedish', 'Hungarian', 'Portugese']
    
    if params[:new_page]
      @startat = params[:new_page]
      params.merge!(session[:search_params])
      params[:new_page] = @startat
    end
    
    unless params[:search_string].blank?
      if params[:new_page].blank?
        @requesturl = Recipe.get_request_url(request.url,request.env['HTTP_HOST'])
      else
        @requesturl = session[:search_url]
        session[:search_url] = nil
      end
      
      @recipeResult = Recipe.get_recipes_from_api(params)
      puts @recipeResult['totalMatchCount']
      session[:search_params] = params
      session[:search_url] = @requesturl
      respond_to do |format|
      format.html { }
        format.js   {}
        format.json { render json: @recipeResult }
      end
    end
  end
  
  def show
    begin
      if Recipe.where("id = ?", params[:id]).blank?
         @recipe = Recipe.get_recipe_from_api(params[:id])
       else
         @dbRecipe = Recipe.find(params[:id])
         @recipe = Recipe.get_recipe_hash(@dbRecipe)
      end
      
      if current_user
        @is_favorite = Favorite.check_if_favorite(@recipe['id'], current_user)
      end
      
      respond_with(@recipe)
    rescue
      render :template => "errors/not_found"
    end
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
