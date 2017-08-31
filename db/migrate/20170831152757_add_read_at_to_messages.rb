class AddReadAtToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :read_by_admin_at, :datetime, default: nil 
  	add_column :messages, :read_by_user_at, :datetime, default: nil 
  end
end
