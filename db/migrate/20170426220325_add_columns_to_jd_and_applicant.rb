class AddColumnsToJdAndApplicant < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :worth, :integer
  	add_column :applicants, :status, :string, default: "none"
  end
end
