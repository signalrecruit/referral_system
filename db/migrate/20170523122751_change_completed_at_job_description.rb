class ChangeCompletedAtJobDescription < ActiveRecord::Migration
  def change
  	remove_column :job_descriptions, :completed, :boolean
  	add_column :job_descriptions, :completed, :boolean, default: false
  end
end
