class IngredientController < ApplicationController
	respond_to :xml, :json, :html

	def index		#GET /ingredient
		@ingredient = Ingredient.all
		respond_with(@ingredient)
	end

	def create	#POST /ingredient
		@ingredient = Ingredient.new(ingredient_params)

		if @ingredient.save
			@ingredients = Ingredient.all
			respond_to do |format|
				format.js
			end
		else
			render "new"
		end
	end

	def new			#GET /ingredient/new
		@ingredient = Ingredient.new
	end
	
	def edit		#GET /ingredient/:id/edit
		@ingredient = Ingredient.find(params[:id])
	end
	
	def show		#GET /ingredient/:id
		@ingredient = Ingredient.find(params[:id])
	end

	def update  #PUT/PATCH /ingredients/:id
		if current_user
			@ingredient = Ingredient.find(params[:id])
			if @ingredient.update(ingredient_params)
					redirect_to @ingredient
			else
					render 'edit'
			end
		else
			require_login
		end
	end


  private
  
  def ingredient_params
		params.permit(:title, :description)
  end
end
