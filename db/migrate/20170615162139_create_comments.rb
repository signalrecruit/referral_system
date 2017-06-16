class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :feedback
      t.references :applicant, index: true, foreign_key: true
      t.references :job_description, index: true, foreign_key: true
      t.references :score, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
