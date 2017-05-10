class AddEarningsToApplicants < ActiveRecord::Migration
  def change
  	add_column :applicants, :earnings, :decimal, default: 0.0
  end
end
