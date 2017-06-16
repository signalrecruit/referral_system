class AddCompanyNameToApplicantRecords < ActiveRecord::Migration
  def change
  	add_column :applicant_records, :company_name, :string
  end
end
