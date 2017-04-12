class AddUpdatedButtonToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :update_button, :boolean, default: false
  end
end
