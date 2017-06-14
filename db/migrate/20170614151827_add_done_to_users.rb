class AddDoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :done, :boolean, default: false
  end
end
