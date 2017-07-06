class AddCUserIdToJd < ActiveRecord::Migration
  def change
  	add_column :job_descriptions, :c_user_id, :integer, default: nil #c_user_id is the id of current_user editing jd
  end
end
