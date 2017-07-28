class AddCopyAndCopyIdToRequirements < ActiveRecord::Migration
  def change
    add_column :requirements, :copy, :boolean, default: false 
    add_column :requirements, :copy_id, :integer, default: nil
  end
end
