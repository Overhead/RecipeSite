class RecipeIngredientController < ApplicationController
	def destroy
		@ri = RecipeIngredient.find(params[:id])
		RecipeIngredient.destroy(@ri)
		redirect_to :back
	end
end
