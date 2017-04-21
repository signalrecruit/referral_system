class RemoveColumnsFromActivities < ActiveRecord::Migration
  def change
  	remove_column :activities, :jd_action, :string
  	remove_column :activities, :requirement_action, :string
  	remove_column :activities, :posted, :boolean, default: false
  	remove_column :activities, :user_action, :string
  end
end
