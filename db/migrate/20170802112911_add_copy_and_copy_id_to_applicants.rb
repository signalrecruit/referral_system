class AddCopyAndCopyIdToApplicants < ActiveRecord::Migration
  def change
  	add_column :applicants, :copy, :boolean, default: false
  	add_column :applicants, :copy_id, :integer, default: nil 
  end
end
