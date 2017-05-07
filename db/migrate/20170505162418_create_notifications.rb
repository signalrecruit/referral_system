class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.datetime :clicked_at, default: nil
      t.boolean :clicked, default: false
      t.string :action
      t.string :notification_type

      t.timestamps null: false
    end
  end
end
