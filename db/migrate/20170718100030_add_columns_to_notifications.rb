class AddColumnsToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :recipient_id, :integer
  	add_column :notifications, :actor_id, :integer 
  	add_column :notifications, :read_at, :datetime
  end
end
