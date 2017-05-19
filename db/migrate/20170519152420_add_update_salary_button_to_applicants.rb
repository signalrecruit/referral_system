class AddUpdateSalaryButtonToApplicants < ActiveRecord::Migration
  def change
  	add_column :applicants, :update_salary_button, :boolean, default: false
  end
end
