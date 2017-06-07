class AddRequirementContentToRequirementScore < ActiveRecord::Migration
  def change
  	add_column :requirement_scores, :requirement_content, :string
  end
end
