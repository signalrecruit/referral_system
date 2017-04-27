class AddWorthToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :worth, :integer
  end
end
