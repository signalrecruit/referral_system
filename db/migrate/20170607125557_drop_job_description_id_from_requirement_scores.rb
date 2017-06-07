class DropJobDescriptionIdFromRequirementScores < ActiveRecord::Migration
  def change
  	remove_column :requirement_scores, :job_description_id
  end
end
