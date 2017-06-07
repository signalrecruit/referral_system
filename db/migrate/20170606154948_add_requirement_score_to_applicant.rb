class AddRequirementScoreToApplicant < ActiveRecord::Migration
  def change
  	add_column :applicants, :requirement_score, :integer, default: 0
  end
end
