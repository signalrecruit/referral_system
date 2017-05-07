class AddApplicantWorthOfJdToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :applicant_worth, :decimal, default: 0.0
  	add_column :job_descriptions, :applicant_percent_worth, :decimal, default: 0.0
  end
end
