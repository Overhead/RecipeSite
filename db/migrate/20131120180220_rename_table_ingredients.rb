class RenameTableIngredients < ActiveRecord::Migration
   def self.up
    rename_table :ingredients, :ingredient
  end

 def self.down
    rename_table :ingredient, :ingredients
 end
end
