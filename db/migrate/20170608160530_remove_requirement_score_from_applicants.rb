class RemoveRequirementScoreFromApplicants < ActiveRecord::Migration
  def change
  	remove_column :applicants, :requirement_score, :integer
  end
end
