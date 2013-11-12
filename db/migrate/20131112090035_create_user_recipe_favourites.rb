class CreateUserRecipeFavourites < ActiveRecord::Migration
  def change
    create_table :user_recipe_favourites do |t|

      t.timestamps
    end
  end
end
