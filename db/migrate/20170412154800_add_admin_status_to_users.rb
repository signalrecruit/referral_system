class AddAdminStatusToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :admin_status, :integer, default: 0
  end
end
