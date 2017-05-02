class AddUserRefToJobDescriptions < ActiveRecord::Migration
  def change
    add_reference :job_descriptions, :user, index: true, foreign_key: true
  end
end
