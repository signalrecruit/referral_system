class AddArchivedByUserToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :archived_by_user, :boolean, default: false
  end
end
