class CreateRequiredExperiences < ActiveRecord::Migration
  def change
    create_table :required_experiences do |t|
      t.string :experience
      t.integer :years
      t.references :job_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
