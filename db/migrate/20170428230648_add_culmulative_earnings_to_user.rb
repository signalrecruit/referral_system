class AddCulmulativeEarningsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :cumulative_earnings, :decimal, default: 0.0
  end
end
