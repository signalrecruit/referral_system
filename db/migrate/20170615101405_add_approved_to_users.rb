class AddApprovedToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :approval, :boolean, default: false
  end
end
