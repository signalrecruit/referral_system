class CreateRequirementScores < ActiveRecord::Migration
  def change
    create_table :requirement_scores do |t|
      t.boolean :input, default: false 
      t.integer :score, default: 0
      t.references :applicant, index: true, foreign_key: true
      t.references :job_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
