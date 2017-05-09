class AddSentByToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :sent_by, :string
  end
end
