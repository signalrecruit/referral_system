class AddCompletedToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :completed, :boolean, default: false
  end
end
