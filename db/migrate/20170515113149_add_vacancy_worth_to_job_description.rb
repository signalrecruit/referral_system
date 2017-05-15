class AddVacancyWorthToJobDescription < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :vacancy_worth, :decimal, default: 0.0
  	add_column :job_descriptions, :vacancy_percent_worth, :decimal, default: 0.0
  end
end
