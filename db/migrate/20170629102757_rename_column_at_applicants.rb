class RenameColumnAtApplicants < ActiveRecord::Migration
  def change
  	rename_column :applicants, :attachment, :cv
  end
end
