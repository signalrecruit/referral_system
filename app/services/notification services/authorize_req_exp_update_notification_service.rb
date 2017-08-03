class AuthorizeReqExpUpdateNotificationService
  def initialize(params)
  	@actor = params[:actor]
  	@action = params[:action]
  	@resource = params[:resource]
  	@resource_type = params[:resource_type]
  end

  def notify_user 
  	create_notification
  end


  private

  def create_notification 
  	Notification.create recipient_id: @resource.job_description.user_id, actor_id: @actor.id, action: @action, resource_id: @resource.id, resource_type: @resource_type,
     actor_username: @actor.username 
  end
end