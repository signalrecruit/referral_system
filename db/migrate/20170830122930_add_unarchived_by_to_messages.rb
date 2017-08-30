class AddUnarchivedByToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :unarchived_by, :string
  end
end
