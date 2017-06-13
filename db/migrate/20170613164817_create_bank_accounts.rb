class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :account_holder
      t.string :account_number
      t.string :bank_name
      t.string :sort_code
      t.text :account_holder_address
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
