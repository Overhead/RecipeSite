class RenameUsersIdInRecipe < ActiveRecord::Migration
  def change
    change_table :recipes do |t|
      t.rename :users_id, :user_id
    end
  end
end
