class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show]	
  layout "admin"

  def index
  	@users = User.all.where(admin: false, admin_status: 0)
  end

  def show
  end


  private

  def set_user
  	@user = User.find(params[:id])
  end
end
