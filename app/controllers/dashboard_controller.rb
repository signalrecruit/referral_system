class DashboardController < ApplicationController

  def index
  	display_analytics
  	if current_user && (current_user.bank_accounts.empty? && current_user.payment_option == "bank") 
  	  flash.now[:warning] = "Hello, #{current_user.fullname}. You choose bank as your payment option. Here is a reminder to fill out your bank account details." 
  	end
  end

  def activity_feed
  end
end
