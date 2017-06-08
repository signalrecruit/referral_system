class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :job_description, index: true, foreign_key: true
      t.references :applicant, index: true, foreign_key: true
      t.decimal :applicant_score

      t.timestamps null: false
    end
  end
end
