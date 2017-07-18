class CompanyContactNotificationService
  def initialize(params)
  	@company = params[:company]
  	@actor = params[:actor]
  	@action = params[:action]
  	@recipient = params[:recipient]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end  

  def notify_user 
  	create_notification
  end
  

  private 

  def create_notification
  	Notification.create recipient_id: @recipient.id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
  	actor_username: @actor.username
  end
end