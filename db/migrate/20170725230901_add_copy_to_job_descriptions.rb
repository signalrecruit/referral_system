class AddCopyToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :copy, :boolean, default: false 
  	add_column :job_descriptions, :copy_id, :integer, default: nil
  end
end
