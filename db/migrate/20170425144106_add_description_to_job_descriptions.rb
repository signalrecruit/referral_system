class AddDescriptionToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :role_description, :text
  end
end
