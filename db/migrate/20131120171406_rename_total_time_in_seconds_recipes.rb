class RenameTotalTimeInSecondsRecipes < ActiveRecord::Migration
  def change
    change_table :recipes do |t|
      t.rename :total_time_seconds, :totalTimeInSeconds
    end
  end
end
