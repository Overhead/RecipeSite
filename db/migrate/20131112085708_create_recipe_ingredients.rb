class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.float :amount
      t.string :unit

      t.timestamps
    end
  end
end
