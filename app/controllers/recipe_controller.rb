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
    
    #If user wants to change page insearch result
    if params[:new_page]
      @startat = params[:new_page]
      params.merge!(session[:search_params])
      params[:new_page] = @startat
    end
    
    unless params[:search_string].blank?
      #Only change request url if the user does a new search, and not on page change
      if params[:new_page].blank?
        @requesturl = Recipe.get_request_url(request.url,request.env['HTTP_HOST'])
      else
        @requesturl = session[:search_url]
        session[:search_url] = nil
      end
      
      @recipeResult = Recipe.get_search_recipes(params)
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
  end
  
  def new     #GET /recipe/new
    @recipe = Recipe.new
    @recipe.recipe_ingredients.build
    @ingredients = Ingredient.all
  end

  def create  #POST /recipe
    @recipe = Recipe.new(recipe_params)

    # Add the user id
    if current_user; @recipe.users_id = current_user.id end

    # Ingredients hash in params
    is = params['ingredients']
    is.each do |k,v|

      # Neede params
      amount = v['amount']
      unit = v['unit']
      ingredient_id = v['ingredient_id'].to_i

      # Only add the recipe_ingredient if the ingredient exists
      if Ingredient.exists?(ingredient_id)
        # Make a new recipe_ingredient
        ingredient = Ingredient.find(ingredient_id)
        recipe_ingredient = RecipeIngredient.new(
          amount: amount,
          unit: unit,
          ingredient: ingredient
          )

        # Add it to the recipe
        @recipe.recipe_ingredients.push(recipe_ingredient)
      end
    end

    if @recipe.save
      redirect_to @recipe
    else
      render "new"
    end
  end

  def destroy #DELETE /recipe/:id
    @recipe = Recipe.find(params[:id])
    @recipe.destroy

    redirect_to recipe_index_path
  end



  private

  def recipe_params
    params.require(:recipe).permit(
      :recipeName,
      :description,
      ingredients: [
        :amount,
        :unit,
        :ingredient_id
      ]
      #,ingredients: [:name, :description]
      )
  end

  def fav_recipe
    if Recipe.where("id = ?", params[:id]).blank?
      if Recipe.where("yummly_id = ?", params[:id]).blank?
        #create yummly recipe, and recipe fav connection to user
      else
        #create only recipe fav connection to user
      end
    else
      
    end
  end
  
  def unfav_recipe
    
  end
  
end
