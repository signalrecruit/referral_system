class AddEditUserIdToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :edit_user_id, :integer, default: nil #edit_user_id is the id of the current user editing a company
  end
end
