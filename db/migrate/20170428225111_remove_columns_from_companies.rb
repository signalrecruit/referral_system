class RemoveColumnsFromCompanies < ActiveRecord::Migration
  def change
  	remove_column :companies, :worth
  	remove_column :companies, :percent_worth
  	remove_column :companies, :earnings
  end
end
