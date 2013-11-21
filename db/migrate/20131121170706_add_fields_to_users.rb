class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :given_name, :string
    add_column :users, :family_name, :string
    add_column :users, :link, :string
    add_column :users, :picture, :string
    add_column :users, :gender, :string
    add_column :users, :locale, :string
  end
end
