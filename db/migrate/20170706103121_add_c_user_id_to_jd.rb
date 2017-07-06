class AddCUserIdToJd < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :edit_user_id, :integer, default: nil #edit_user_id is the id of current_user editing jd
  end
end
