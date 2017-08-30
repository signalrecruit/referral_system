class AddArchivedByAdminToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :archived_by, :string
  	add_column :messages, :drafted_by, :string 
  	remove_column :messages, :archived_by_user
  end
end
