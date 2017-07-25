class AddCopyToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :copy, :boolean, default: false
  	add_column :companies, :copy_id, :integer, default: nil
  end
end
