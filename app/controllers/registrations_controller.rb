class RegistrationsController < Devise::RegistrationsController
  
  protected

  def after_update_path_for(resource)
    if resource.admin?
      layout "admin"
      admin_dashboard_url
    else
      root_url
    end
  end
end