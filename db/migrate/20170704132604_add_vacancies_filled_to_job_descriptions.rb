class AddVacanciesFilledToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :vacancies_filled, :boolean, default: false 
  end
end
