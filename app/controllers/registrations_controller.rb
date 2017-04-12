class RegistrationsController < Devise::RegistrationsController
  layout "admin"
  
  protected

  def after_update_path_for(resource)
    if resource.admin?
      admin_dashboard_url
    else
      root_url
    end
  end
end