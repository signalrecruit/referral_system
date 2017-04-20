class AddColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :fullname, :string
  	add_column :users, :phonenumber, :string 
  	remove_column :users, :username, :string,  default: "Guest User"
  	add_column :users, :username, :string
  end
end
