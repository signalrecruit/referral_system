class CreateQualifications < ActiveRecord::Migration
  def change
    create_table :qualifications do |t|
      t.string :certificate
      t.string :field_of_study
      t.references :job_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
