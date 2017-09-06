class CreateBugReports < ActiveRecord::Migration
  def change
    create_table :bug_reports do |t|
      t.string :error_message
      t.string :resolution_status

      t.timestamps null: false
    end
  end
end
