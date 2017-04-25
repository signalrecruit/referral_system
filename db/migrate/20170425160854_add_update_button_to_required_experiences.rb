class AddUpdateButtonToRequiredExperiences < ActiveRecord::Migration
  def change
  	add_column :required_experiences, :update_button, :boolean, default: false
  end
end
