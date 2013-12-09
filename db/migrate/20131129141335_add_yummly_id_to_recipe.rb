class AddYummlyIdToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :yummly_id, :text
  end
end
