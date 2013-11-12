class AddBelongsToToUserRecipeHistory < ActiveRecord::Migration
  def change
    add_reference :user_recipe_histories, :user, index: true
    add_reference :user_recipe_histories, :recipe, index: true
  end
end
