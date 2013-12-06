class IngredientController < ApplicationController
	respond_to :xml, :json, :html

	def index		#GET /ingredient
		@ingredient = Ingredient.all
		respond_with(@ingredient)
	end

	def create	#POST /ingredient
		@ingredient = Ingredient.new(ingredient_params)

		if @ingredient.save
			redirect_to @ingredient
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



  private
  
  def ingredient_params
		params.require(:ingredient).permit(:title, :description)
  end
end
