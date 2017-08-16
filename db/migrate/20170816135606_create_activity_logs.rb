class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string :actor_fullname
      t.integer :actor_id
      t.string :action
      t.integer :resource_id
      t.string :resource_type

      t.timestamps null: false
    end
  end
end
