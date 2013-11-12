class AddBelongsToToUserRecipeFavourite < ActiveRecord::Migration
  def change
    add_reference :user_recipe_favourites, :user, index: true
    add_reference :user_recipe_favourites, :recipe, index: true
  end
end
