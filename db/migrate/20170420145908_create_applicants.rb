class CreateApplicants < ActiveRecord::Migration
  def change
    create_table :applicants do |t|
      t.string :name
      t.string :email
      t.string :phonenumber
      t.string :location
      t.integer :min_salary
      t.integer :max_salary
      t.references :company, index: true, foreign_key: true
      t.references :job_description, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :attachment
      t.boolean :update_button, default: false

      t.timestamps null: false
    end
  end
end
