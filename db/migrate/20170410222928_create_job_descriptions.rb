class CreateJobDescriptions < ActiveRecord::Migration
  def change
    create_table :job_descriptions do |t|
      t.string :job_title
      t.integer :experience
      t.decimal :min_salary
      t.decimal :max_salary
      t.integer :vacancies
      t.boolean :update_button, default: false
      t.references :company, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
