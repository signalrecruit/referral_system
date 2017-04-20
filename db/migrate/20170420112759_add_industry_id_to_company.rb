class AddIndustryIdToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :industry_id, :integer 
  	add_column :companies, :alias_name, :string
  	add_index :companies, :industry_id
  end
end
