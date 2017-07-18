class RemoveColumnFromNotification < ActiveRecord::Migration
  def change
  	remove_column :notifications, :clicked_at
  	remove_column :notifications, :clicked 
  	remove_column :notifications, :notification_type
  end
end
