class AddColumnToNotifications < ActiveRecord::Migration
  def change
  	add_column :notifications, :seen_at, :datetime
  end
end
