class AddStacktraceToBugReports < ActiveRecord::Migration
  def change
  	add_column :bug_reports, :stacktrace, :text, array: true, default: []
  end
end
