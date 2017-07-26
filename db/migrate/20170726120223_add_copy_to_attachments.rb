class AddCopyToAttachments < ActiveRecord::Migration
  def change
  	add_column :attachments, :copy, :boolean, default: false
  	add_column :attachments, :copy_id, :integer, default: nil
  end
end
