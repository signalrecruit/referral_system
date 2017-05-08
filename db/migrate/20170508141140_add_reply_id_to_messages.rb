class AddReplyIdToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :reply_id, :integer, default: 0
  end
end
