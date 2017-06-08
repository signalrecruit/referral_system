class AddJobDescriptionIdToRequirementScores < ActiveRecord::Migration
  def change
    add_reference :requirement_scores, :job_description, index: true, foreign_key: true
  end
end
