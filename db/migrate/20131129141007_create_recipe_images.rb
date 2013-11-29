class CreateRecipeImages < ActiveRecord::Migration
  def change
    create_table :recipe_images do |t|
      t.text :image_url
      t.references :recipe, index: true
      t.timestamps
    end
  end
end
