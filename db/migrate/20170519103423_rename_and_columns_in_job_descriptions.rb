class RenameAndColumnsInJobDescriptions < ActiveRecord::Migration
  def change
  	rename_column :job_descriptions, :worth, :actual_worth
  	add_column :job_descriptions, :potential_worth, :decimal, default: 0.0
  end
end
