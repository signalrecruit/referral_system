class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.string :recipient_id
      t.boolean :read, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
