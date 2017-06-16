class CreateApplicantRecords < ActiveRecord::Migration
  def change
    create_table :applicant_records do |t|
      t.references :job_description, index: true, foreign_key: true
      t.string :role
      t.references :score, index: true, foreign_key: true
      t.decimal :applicant_score
      t.references :comment, index: true, foreign_key: true
      t.string :feedback
      t.references :applicant, index: true, foreign_key: true
      t.string :applicant_name
      t.string :applicant_status

      t.timestamps null: false
    end
  end
end
