class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  protected


  def configure_permitted_parameters

    if resource_class == User
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :fullname, :phonenumber])
      devise_parameter_sanitizer.permit(:account_update, keys: [:username, :fullname, :phonenumber])
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
    Activity.create! trackable: trackable, action: action, user_id: user_id
  end

  def reverse_tracking_activity(action, trackable_id)
    activity = Activity.find_by action: action, trackable_id: trackable_id
    activity.delete if !activity.nil?
  end

  def update_activity(action, trackable_id)
    activity = Activity.find_by trackable_id: trackable_id
    activity.update(action: action)
  end
end
