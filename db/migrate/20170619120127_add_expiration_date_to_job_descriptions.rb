class AddExpirationDateToJobDescriptions < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :expiration_date, :datetime, default: DateTime.now
  end
end
