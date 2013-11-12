class CreateUserRecipeHistories < ActiveRecord::Migration
  def change
    create_table :user_recipe_histories do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
