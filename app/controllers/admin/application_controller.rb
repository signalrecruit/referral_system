class Admin::ApplicationController < ApplicationController
  include Authorization	
  before_action :authorize_user!
  layout "admin"

  

  private

  def authorize_user!
  	authenticate_user!

  	unless current_user.admin?
  	  redirect_to root_path, alert: "YOU ARE NOT AUTHORIZED! You lack certain permissions to proceed further"
  	end
  end
end
