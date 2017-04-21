class RenameCompanyAction < ActiveRecord::Migration
  def change
  	rename_column :activities, :company_action, :action
  end
end
