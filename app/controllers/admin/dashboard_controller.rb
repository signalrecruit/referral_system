class Admin::DashboardController < Admin::ApplicationController
  layout "admin"	

  def dashboard
  	display_analytics
  end

  
  def activity_feed
  end 
end
