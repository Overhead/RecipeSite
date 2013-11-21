class RenameTables < ActiveRecord::Migration
    def self.up
    rename_table :cuisine, :cuisines
    rename_table :ingredient, :ingredients
  end

 def self.down
    rename_table :cuisines, :cuisine
    rename_table :ingredients, :ingredient
 end
end
