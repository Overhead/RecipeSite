class AddTotalTimeInSecondsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :total_time_seconds, :integer
  end
end
