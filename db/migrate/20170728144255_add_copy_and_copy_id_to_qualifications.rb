class AddCopyAndCopyIdToQualifications < ActiveRecord::Migration
  def change
  	add_column :qualifications, :copy, :boolean, default: false 
  	add_column :qualifications, :copy_id, :integer, default: nil
  end
end
