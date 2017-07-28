class AddCopyAndCopyIdToRequiredExperiences < ActiveRecord::Migration
  def change
  	add_column :required_experiences, :copy, :boolean, default: false
  	add_column :required_experiences, :copy_id, :integer, default: nil
  end
end
