class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.text :name
      t.text :source_id
      t.text :source

      t.timestamps
    end
  end
end
