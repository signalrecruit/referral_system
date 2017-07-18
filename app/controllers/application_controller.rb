class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Error::ErrorHandler

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :unapproved_users, :new_companies, :uncompleted_roles, :new_applicants
  
  def unapproved_users
    @unapproved_users = User.all.where(admin: false, approval: false)  
  end

  def new_companies 
    @new_companies = Company.all.where(contacted: false)
  end

  def uncompleted_roles 
    @uncompleted_roles = JobDescription.all.where(vacancies_filled: false)
  end

  def new_applicants
    @new_applicants = Applicant.all.where(status: "none")
  end



  protected


  def configure_permitted_parameters

    if resource_class == User
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fullname, :phonenumber, :payment_option])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :fullname, :phonenumber, :payment_option])
    end
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_url
    else 
      root_url
    end
  end
  

  private

  def track_activity(trackable, action, user_id)
    activity = Activity.create! trackable: trackable, action: action, user_id: user_id

    if activity.trackable_type == "JobDescription" && JobDescription.find(activity.trackable_id).
      company.deal?
      activity.update(permitted: true)
    end
  end

  def activity_exists?(trackable_id, trackable_type, action=nil)
    if action.nil?
      activity = Activity.find_by trackable_id: trackable_id, trackable_type: trackable_type
      @activity = activity
      return false if activity 
    else
      activity = Activity.find_by trackable_id: trackable_id, trackable_type: trackable_type, action: action
      @activity = activity
      return true if activity
    end
  end

  def create_notification(action, notification_type)
    Notification.create! action: action, notification_type: notification_type  
  end

  def display_analytics
    total_revenue
    total_number_of_hired_applicants
    total_number_of_company_deals
    top_earner
  end

  def total_revenue
    @completed_jds = []
    JobDescription.all.each do |jd|
      if jd.applicants.all? { |applicant| applicant.hired? }
        @completed_jds << jd.actual_worth
      end 
      @total_revenue = @completed_jds.inject(0){ |sum, x| sum + x }
    end 
  end

  def total_number_of_hired_applicants
    @number_of_hired_applicants = Applicant.all.where(status: "hired").count     
  end

  def total_number_of_company_deals
    @number_of_deals = Company.all.where(deal: true).count
  end

  def top_earner
    if User.any? { |user| user.cumulative_earnings != 0 } 
      @top_earner = User.all.order(cumulative_earnings: :desc).first
    else 
      @top_earner = nil 
    end
  end


  def on_success msg, path 
    flash[:success] = msg 
    redirect_to path 
  end

  def on_failure msg, path 
    flash[:alert] = msg 
    render path
  end

  def on_caution msg, path 
    flash[:alert] = msg 
    redirect_to path
  end
end
