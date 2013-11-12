class AddBelongsToToRecipeIngredients < ActiveRecord::Migration
  def change
    add_reference :recipe_ingredients, :ingredients, index: true
    add_reference :recipe_ingredients, :recipe, index: true
  end
end
