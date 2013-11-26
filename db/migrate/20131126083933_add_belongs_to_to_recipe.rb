class AddBelongsToToRecipe < ActiveRecord::Migration
  def change
    add_reference :recipes, :users, index: true, :null => true
  end
end
