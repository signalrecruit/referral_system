class CompanyUpdateNotificationService 
  def initialize(params)
  	@actor = params[:actor]
  	@action = params[:action]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end

  def notify_admin 
  	create_notification
  end


  private 

  def create_notification
    if admin_with_role_on_this_resource? 
   	  role = Role.find_by role: "owner", resource_id: @resource.id, resource_type: @resource_type
   	  Notification.create recipient_id: role.user_id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
      actor_username: @actor.username	
    end
  end

  def admin_with_role_on_this_resource? 
    role = Role.find_by role: "owner", resource_id: @resource.id, resource_type: @resource_type
    if role 
      true 
    else
      false 
    end
  end
end