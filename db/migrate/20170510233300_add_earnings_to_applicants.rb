class AddEarningsToApplicants < ActiveRecord::Migration
  def change
  	remove_column :applicants, :earnings, :decimal, default: 0.0
  end
end
