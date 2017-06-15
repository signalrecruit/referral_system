class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :approve, :disapprove]	
  layout "admin"

  def index
  	@users = User.all.order(created_at: :asc).where(admin: false, admin_status: 0)
  end

  def show
  end

  def approve
    @user.update(approval: true)
    redirect_to :back
  end

  def disapprove
    @user.update(approval: false)
    redirect_to :back
  end

  
  private

  def set_user
  	@user = User.find(params[:id])
  end
end
