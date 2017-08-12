class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :approve, :disapprove]	
  layout "admin"

  def index
  	@users = User.all.includes(:companies, :applicants, :job_descriptions).order(created_at: :asc).where(admin: false, admin_status: 0)
    fresh_when last_modified: @users.maximum(:updated_at)
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

  def reset_cumulative_earnings 
    index
    @users.each do |user|
      @applicant_earnings = 0.0 
      @jd_earnings = 0.0
      user.applicants.each do |applicant|
        @applicant_earnings += applicant.earnings if applicant.hired?
      end

      user.job_descriptions.each do |jd|
        @jd_earnings += jd.earnings
      end
      user.update(cumulative_earnings: @applicant_earnings + @jd_earnings)
    end
    redirect_to :back
  end

  
  private

  def set_user
  	@user = User.find(params[:id])
    fresh_when @user
  end
end
