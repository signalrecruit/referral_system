class ChangeScoreColumnOnRequirementScores < ActiveRecord::Migration
  def change
  	change_column :requirement_scores, :score, :decimal
  end
end
