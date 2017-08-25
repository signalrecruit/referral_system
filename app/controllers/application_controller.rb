class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Error::ErrorHandler

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :unapproved_users, :new_companies, :uncompleted_roles, :new_applicants, :unread_notifications, :unread_notifications_count,
  :all_notifications, :company_notifications, :unseen_notifications
  
  def unapproved_users
    @unapproved_users = User.all.where(admin: false, approval: false)  
  end

  def new_companies 
    @new_companies = Company.all.where(contacted: false)
  end

  def company_notifications
    @company_notifications = if current_user
                                Notification.where(recipient_id: current_user, read_at: nil, resource_type: "company").all.count
                              else 
                                Notification.none  
                              end
  end

  def uncompleted_roles 
    @uncompleted_roles = JobDescription.all.where(vacancies_filled: false)
  end

  def new_applicants
    @new_applicants = Applicant.all.where(status: "none")
  end

  def unseen_notifications
    @unseen_notifications = if current_user 
                              Notification.where(recipient_id: current_user.id, seen_at: nil).all 
                            else 
                              Notification.none
                            end    
  end
  
  def unread_notifications 
    @unread_notifications = if current_user
                              Notification.where(recipient_id: current_user.id, read_at: nil).all
                            else
                              Notification.none
                            end  
  end

  def unread_notifications_count
    @unread_notifications_count = if current_user
                                    Notification.where(recipient_id: current_user.id, read_at: nil).all.count
                                  else 
                                    0
                                  end  
  end

  def all_notifications
    @all_notifications = if current_user 
                           Notification.where(recipient_id: current_user.id).all.order(created_at: :asc)
                         else 
                           Notification.none  
                         end    
  end

  # add an extra parameter to check for differences in copy and original
  def change_in_data existing_attributes, update_attributes 
    existing_attributes != update_attributes
  end

  def delete_copy_of_resource(resource)
    if resource_copy = resource.class.name.constantize.find_by(copy: true, copy_id: resource.id)
      resource_copy.delete
    end
  end

  def implement_authorization_policy_if_applicable(resource)
    jd = resource.job_description
    role = Role.find_by role: "owner", resource_id: jd.id, resource_type: jd.class.name
    if role 
      Role.create role: "owner", resource_id: resource.id, resource_type: resource.class.name, user_id: role.user_id
    end
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
      activity.update permitted: true if !activity.permitted? && activity.trackable_type == "JobDescription"
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
      if jd.applicants.any?
        if jd.applicants.all? { |applicant| applicant.hired? }
          @completed_jds << jd.actual_worth
        end 
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
    flash.now[:alert] = msg 
    render path
  end

  def on_caution msg, path 
    flash[:alert] = msg 
    redirect_to path
  end
end
