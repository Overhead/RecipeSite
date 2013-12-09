class RenameTableCuisines < ActiveRecord::Migration
  def self.up
    rename_table :cuisines, :cuisine
  end

 def self.down
    rename_table :cuisine, :cuisines
 end
end
