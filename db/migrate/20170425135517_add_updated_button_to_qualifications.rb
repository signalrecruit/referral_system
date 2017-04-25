class AddUpdatedButtonToQualifications < ActiveRecord::Migration
  def change
  	add_column :qualifications, :update_button, :boolean, default: false
  end
end
