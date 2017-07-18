class AddColumnsToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :recipient_id, :integer
  	add_column :notifications, :actor_id, :integer 
  	add_column :notifications, :read_at, :datetime
  	add_column :notifications, :resource_id, :integer 
  	add_column :notifications, :resource_type, :string
  	add_column :notifications, :actor_username, :string 
  end
end
