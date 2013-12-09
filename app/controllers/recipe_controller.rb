class RecipeController < ApplicationController
  respond_to :xml, :json, :html
  def index
    if current_user
      @recipes = current_user.recipes
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
      @search_word = params[:search_string]
      session[:search_params] = params
      session[:search_url] = @requesturl
      respond_to do |format|
      format.html { }
        format.js   {}
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
    rescue => ex
      logger.error ex.message
      redirect_to :root
    end
  end
  
  def new     #GET /recipe/new
    if current_user
      @recipe = Recipe.new
      @recipe.recipe_ingredients.build
      @ingredients = Ingredient.all
      @new_ingredient = Ingredient.new
    else
      require_login
    end
  end

  def create  #POST /recipe
    begin 
    @recipe = Recipe.new(recipe_params)

    # Add the user id
    if current_user; @recipe.user_id = current_user.id end

    # Ingredients hash in params
    if params['ingredients']
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
    end

    # Image url
    if params['image_url']
      @recipe.recipe_images.new(:image_url => params['image_url'])
    end

    if @recipe.save
      redirect_to @recipe
    else
      render "new"
    end
    rescue => ex
      logger.error ex.message
      redirect_to :root
    end
  end

  def destroy #DELETE /recipe/:id
    if current_user
      @recipe = Recipe.find(params[:id])

      if @recipe.user_id == current_user.id
        if !Favorite.where("source_id = ?", @recipe.id).blank?
          Favorite.destroy(Favorite.where("source_id = ?", @recipe.id))
        end
        @recipe.destroy
      end

      redirect_to "/profile"
    else
      require_login
    end
  end

  
  def update  #PUT/PATCH /recipe/:id
    if current_user

      @recipe = Recipe.find(params[:id])

      if @recipe.update(recipe_params)
        redirect_to @recipe
      else
        render "edit"
      end
    else
      require_login
    end
  end

  def edit    #GET /recipe/:id/edit
    @recipe = Recipe.find(params[:id])
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
      ],
      recipe_ingredients_attributes: [
        [
          :amount,
          :unit,
          :id
        ]
      ],
      recipe_images_attributes: [
        [
          :image_url,
          :id
        ]
      ]
      #,ingredients: [:name, :description]
      )
  end  
end
