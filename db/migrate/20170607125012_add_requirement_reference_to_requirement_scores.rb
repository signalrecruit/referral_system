class AddRequirementReferenceToRequirementScores < ActiveRecord::Migration
  def change
    add_reference :requirement_scores, :requirement, index: true, foreign_key: true
  end
end
