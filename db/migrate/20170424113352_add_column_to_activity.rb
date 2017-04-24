class AddColumnToActivity < ActiveRecord::Migration
  def change
  	add_column :activities, :permitted, :boolean, default: false
  end
end
