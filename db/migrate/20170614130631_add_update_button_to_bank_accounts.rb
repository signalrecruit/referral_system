class AddUpdateButtonToBankAccounts < ActiveRecord::Migration
  def change
  	add_column :bank_accounts, :update_button, :boolean, default: false
  end
end
