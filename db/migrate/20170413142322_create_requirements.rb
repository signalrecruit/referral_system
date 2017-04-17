class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.text :content
      t.boolean :update_button, default: false
      t.references :job_description, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
