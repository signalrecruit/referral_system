class AddPostedToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :posted, :boolean, default: false
  end
end
