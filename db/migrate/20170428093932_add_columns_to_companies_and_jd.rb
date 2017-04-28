class AddColumnsToCompaniesAndJd < ActiveRecord::Migration
  def change
  	add_column :companies, :percent_worth, :integer, default: 0
  	add_column :companies, :earnings, :integer, default: 0
  	add_column :job_descriptions, :percent_worth, :integer, default: 0
  	add_column :job_descriptions, :earnings, :integer, default: 0
  	add_column :job_descriptions, :number_of_applicants, :integer
  end
end
