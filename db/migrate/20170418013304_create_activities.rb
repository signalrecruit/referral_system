class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.references :trackable, polymorphic: true, index: true
      t.string :user_action
      t.string :company_action
      t.string :jd_action
      t.string :requirement_action

      t.timestamps null: false
    end
  end
end
