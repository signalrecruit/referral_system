class AddCopyAndCopyIdToRequirementScores < ActiveRecord::Migration
  def change
  	add_column :requirement_scores, :copy, :boolean, default: false 
  	add_column :requirement_scores, :copy_id, :integer, default: nil
  end
end
