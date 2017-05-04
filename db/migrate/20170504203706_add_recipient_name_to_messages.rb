class AddRecipientNameToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :recipient_name, :string
  end
end
