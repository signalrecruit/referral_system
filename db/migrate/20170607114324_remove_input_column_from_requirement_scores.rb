class RemoveInputColumnFromRequirementScores < ActiveRecord::Migration
  def change
  	remove_column :requirement_scores, :input
  end
end
