class AddPaymentMethodToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :payment_option, :string, default: "none"
  end
end
