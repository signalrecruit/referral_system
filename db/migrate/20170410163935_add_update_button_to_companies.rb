class AddUpdateButtonToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :update_button, :boolean, default: false
  end
end
