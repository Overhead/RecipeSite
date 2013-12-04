class DropTableUserRecipeFavourites < ActiveRecord::Migration
  def change
    drop_table :user_recipe_favourites
    drop_table :user_recipe_histories
  end
end
