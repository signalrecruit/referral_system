class ChangeIntegerColumnsToDecimal < ActiveRecord::Migration
  def change
  	remove_column :job_descriptions, :worth, :integer
  	add_column :job_descriptions, :worth, :decimal, default: 0.0

  	remove_column :job_descriptions, :percent_worth, :integer 
  	add_column :job_descriptions, :percent_worth, :decimal, default: 0.0
  end
end
