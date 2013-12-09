class CreateRecipeCuisines < ActiveRecord::Migration
  def change
    create_table :recipe_cuisines do |t|
      t.belongs_to :recipe, index: true
      t.belongs_to :cuisine, index: true

      t.timestamps
    end
  end
end
