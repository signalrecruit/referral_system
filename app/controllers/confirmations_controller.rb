class ConfirmationsController < Devise::ConfirmationsController
  
  private 

  def after_confirmation_path_for(resource_name, resource)
  	unless resource.admin?
  	  NewUserSignUpNotificationService.new({ actor: resource, action: "sign up", resource: resource, resource_type: resource.class.name }).notify_admin
  	end
  	user_session_url
  end
end
