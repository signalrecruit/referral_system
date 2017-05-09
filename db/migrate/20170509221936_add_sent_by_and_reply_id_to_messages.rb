class AddSentByAndReplyIdToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :sent_by, :string
  	add_column :messages, :reply_id, :integer, default: 0
  end
end
