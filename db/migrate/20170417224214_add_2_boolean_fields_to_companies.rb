class Add2BooleanFieldsToCompanies < ActiveRecord::Migration
  def change
  	add_column :companies, :contacted, :boolean, default: false 
  	add_column :companies, :deal, :boolean, default: false
  end
end
