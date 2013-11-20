class RenameTitleTorecipeNameRecipes < ActiveRecord::Migration
  def change
    change_table :recipes do |t|
      t.rename :title, :recipeName
    end
  end
end
