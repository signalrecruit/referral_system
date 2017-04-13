class RegistrationsController < Devise::RegistrationsController
  layout :choose_layout

  def edit
  end


  private

  def choose_layout
    resource.admin? ? "admin" : "application"
  end
  
  protected

  def after_update_path_for(resource)
    if resource.admin?
      admin_dashboard_url
    else
      root_url
    end
  end
end